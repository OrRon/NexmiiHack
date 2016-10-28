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
    var releasedAction:(()->())?
    var pushedAction:(()->())?
    let color = UIColor(red:1.00, green:0.25, blue:0.51, alpha:1.00)
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
        pushedAction?()
        borders.enumerated().forEach { (index,border) in
            UIView.animateKeyframes(withDuration: 1.5, delay: 0.3 * Double(index), options: UIViewKeyframeAnimationOptions.repeat, animations: {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.pushed = false
            self.releasedAction?()
            self.borders.enumerated().forEach { (index,border) in
                border.layer.removeAllAnimations()
            }
        }
        
        
    }
    
    override init(frame: CGRect) {
        let bound = CGRect(origin: CGPoint(x:0,y:0), size: frame.size)
        circle = UIView(frame: bound)
        circle.layer.cornerRadius = bound.size.width/2
        circle.backgroundColor = color
        
        borders = [UIView(frame: bound),UIView(frame: bound),UIView(frame: bound)]
        super.init(frame: frame)
        
        borders.forEach { view in
            view.layer.cornerRadius = frame.size.width/2
            view.layer.borderWidth = 2.0
            view.layer.borderColor = color.cgColor
            self.addSubview(view)
        }
        
        
        self.addSubview(circle)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
