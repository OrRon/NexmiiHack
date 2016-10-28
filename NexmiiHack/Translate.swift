//
//  Translate.swift
//  NexmiiHack
//
//  Created by Or on 27/10/2016.
//  Copyright © 2016 Or. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

let key = "<Yandex key>"

enum Language:String {
    case en = "en"
    case es = "es"
}


struct Translate {
    
    static func to(_ lang:Language, fromLang:Language, text:String, complition:@escaping (String)->()) {
        let url = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=\(key)&text=\(text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&lang=\(fromLang.rawValue)-\(lang.rawValue)"
        print(url)
        Alamofire.request(url).responseJSON { (response) in
            if let JSON = response.result.value {
                let dict = JSON as! NSDictionary
                let arr = dict.object(forKey:"text") as! NSArray
                let returnedText = arr.firstObject! as! String
                complition(returnedText)
            }
        }
    }
    
}

func convertStringToDictionary(text: String) -> [String:AnyObject]? {
    if let data = text.data(using: String.Encoding.utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
        } catch let error as NSError {
            print(error)
        }
    }
    return nil
}
