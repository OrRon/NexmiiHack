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

enum MessageType {
    case Sent
    case Received
}

struct Message {
    let text: String
    let type: MessageType
    let id: String
}


extension Message : Equatable {}

func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.id == rhs.id
}

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segUser: UISegmentedControl!
    
    @IBOutlet weak var placeholderRecord: UIView!
    
    var reloadableAdapter: ReloadableViewLayoutAdapter!
    var recordButton:RecordButton!
    let speechToText = SpeechToText()
    let textToSpeech = TextToSpeech()
    
    var pushKey = "<PushKey>"

    override func viewDidLayoutSubviews() {
        self.recordButton.center = CGPoint(x:self.view.frame.width/2 , y: self.recordButton.center.y)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.speechToText.authorize()
        self.reloadableAdapter = ReloadableViewLayoutAdapter(reloadableView: self.collectionView)
        self.collectionView.delegate = self.reloadableAdapter
        self.collectionView.dataSource = self.reloadableAdapter
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Push"), object: nil, queue: nil) { notif in
            print("from controller \(notif.userInfo!["msg"]!)")
            let msg = notif.userInfo!["msg"] as! String
            self.textToSpeech.speak(text: msg)
            self.messages.append(Message(text: msg, type: .Received, id: UUID().uuidString))
        }
        recordButton = RecordButton(frame: CGRect(x: self.view.frame.width/2, y: 580, width: 63, height: 63))
        self.view.addSubview(recordButton)
        recordButton.pushedAction = {
            print("Pushed!")
            self.speechToText.start(locale: "es")
            
        }
        recordButton.releasedAction = {
            let proccesedData = self.speechToText.stop()
            print(proccesedData)
            self.send(string: proccesedData)
            
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
    
    func send(string:String) {
        //self.messages.append("Hey There... \(messages.count)")
        self.messages.append(Message(text: string, type: .Sent, id: UUID().uuidString))
        Translate.to(.en,fromLang:.es, text: string) { str in
            print(str)
            OneSignal.postNotification(["contents": ["en": str], "include_player_ids": [self.pushKey]])
        }
    }
    
    var messages = [Message]() {
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

