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
import OneSignal

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segUser: UISegmentedControl!
    
    var reloadableAdapter: ReloadableViewLayoutAdapter!
    
    var pushKey = "0f23a9c1-e65f-4e2a-91b4-c022ce335ee9"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadableAdapter = ReloadableViewLayoutAdapter(reloadableView: self.collectionView)
        self.collectionView.delegate = self.reloadableAdapter
        self.collectionView.dataSource = self.reloadableAdapter
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Push"), object: nil, queue: nil) { notif in
            print("from controller \(notif.userInfo!["msg"]!)")
            let msg = notif.userInfo!["msg"] as! String
            self.messages.append(msg)
        }
    }
    
    @IBAction func onUserChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pushKey = "0f23a9c1-e65f-4e2a-91b4-c022ce335ee9"
        }
        else {
            pushKey = "314b1639-0fb8-44a9-9038-fd706d8588f4"
        }
    }
    
    @IBAction func onTestClick(_ sender: UIButton) {
        //self.messages.append("Hey There... \(messages.count)")
        Translate.to(.es,fromLang:.en, text: "Hey There... \(messages.count)") { str in
            print(str)
            OneSignal.postNotification(["contents": ["en": str], "include_player_ids": [self.pushKey]])
        }
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

