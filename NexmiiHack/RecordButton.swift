//
//  RecordButton.swift
//  NexmiiHack
//
//  Created by Or on 28/10/2016.
//  Copyright © 2016 Or. All rights reserved.
//

import UIKit

class RecordButton: UIView {

    var borders:[UIView]!
    var pushed = false
    var circle:UIView!
    var released:(()->())?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        
    }
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !pushed else {
            return
        }
        pushed = true
        
        borders.enumerated().forEach { (index,border) in
            UIView.animateKeyframes(withDuration: 2, delay: 0.3 * Double(index), options: UIViewKeyframeAnimationOptions.repeat, animations: {
                border.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                }, completion: { completed in
                    border.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard pushed else {
            return
        }
        pushed = false
        
        borders.enumerated().forEach { (index,border) in
            border.layer.removeAllAnimations()
        }
    }
    
    override func awakeFromNib() {
        circle = UIView(frame: self.frame)
        circle.layer.cornerRadius = frame.size.width/2
        circle.backgroundColor = UIColor.red
        
        borders = [UIView(frame: frame),UIView(frame: frame),UIView(frame: frame)]
        
        
        borders.forEach { view in
            view.layer.cornerRadius = frame.size.width/2
            view.layer.borderWidth = 2.0
            view.layer.borderColor = UIColor.red.cgColor
            self.addSubview(view)
        }
        
        
        self.addSubview(circle)
        self.backgroundColor = UIColor.clear
    }
    

}
