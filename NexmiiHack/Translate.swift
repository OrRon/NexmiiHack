//
//  Translate.swift
//  NexmiiHack
//
//  Created by Or on 27/10/2016.
//  Copyright © 2016 Or. All rights reserved.
//

import Foundation
import Alamofire


let key = "trnsl.1.1.20161027T192107Z.6b76d233595ccd0c.c25ed5e580c73d6d13ce2a2bf682cec6860bec4e"

enum Language:String {
    case en = "en"
    case es = "es"
}


struct Translate {
    
    static func to(_ lang:Language, fromLang:Language, text:String, complition:(String)->()) {
        Alamofire.request("https://translate.yandex.net/api/v1.5/tr.json/translate?key=\(key)&text=Hello%20Vladimir&lang=en-es").responseJSON { (response) in
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                print(lang.rawValue)
            }
        }
    }
    
}
