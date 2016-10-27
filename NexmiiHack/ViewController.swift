//
//  ViewController.swift
//  NexmiiHack
//
//  Created by Or on 27/10/2016.
//  Copyright © 2016 Or. All rights reserved.
//

import UIKit
import LayoutKit
import Dwifft

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var reloadableAdapter: ReloadableViewLayoutAdapter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadableAdapter = ReloadableViewLayoutAdapter(reloadableView: self.collectionView)
        self.collectionView.delegate = self.reloadableAdapter
        self.collectionView.dataSource = self.reloadableAdapter
    }
    
    @IBAction func onTestClick(_ sender: UIButton) {
        self.messages.append("Hey There... \(messages.count)")
    }
    
    var messages = [String]() {
        willSet {
            let diff = self.messages.diff(newValue)

            let batchUpdates: BatchUpdates = {
                var updates = BatchUpdates()
                
                updates.insertItems = diff.insertions.map({ IndexPath(row: $0.idx, section: 0) })
                
                return updates
            }()
            
            if batchUpdates.insertItems.count == 0 {
                return
            }
            
            let layouts = newValue.map{ $0.getLayout() }
            
            reloadableAdapter.reload(width:self.collectionView.frame.width, synchronous: false, batchUpdates: batchUpdates, layoutProvider: {
                return [Section(header: nil, items: layouts, footer: nil)]
            }) {
                self.collectionView.scrollToItem(at: IndexPath(row: self.messages.count - 1, section: 0),
                                                 at: .bottom,
                                                 animated: true)
            }
        }
    }
}

extension String {
    func getLayout() -> Layout {
        return
            InsetLayout<UIView>(insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15),
                            sublayout: LabelLayout<UILabel>(text:self))
    }
}

