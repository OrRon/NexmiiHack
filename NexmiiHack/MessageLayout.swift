//
//  MessageLayout.swift
//  NexmiiHack
//
//  Created by Vladimir Kofman on 27/10/2016.
//  Copyright © 2016 Or. All rights reserved.
//

import LayoutKit


class BubbleViewSend: UIView {
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: 5, dy: 5), cornerRadius: 10)
        UIColor(red:0.77, green:0.79, blue:0.91, alpha:1.00).setFill()
        path.fill()
        
        let triPath = UIBezierPath()
        path.move(to: CGPoint(x:20, y: rect.size.height-5))
        path.addLine(to: CGPoint(x: 20, y: rect.size.height))
        path.addLine(to: CGPoint(x: 20+3+3, y: rect.size.height-5))
        path.addLine(to: CGPoint(x:20, y: rect.size.height-5))
        UIColor(red:0.77, green:0.79, blue:0.91, alpha:1.00).setFill()
        path.fill()
    }
    
}

class BubbleViewRecv: UIView {
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: 5, dy: 5), cornerRadius: 10)
        UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00).setFill()
        path.fill()
        
        let triPath = UIBezierPath()
        path.move(to: CGPoint(x:rect.size.width-20, y: rect.size.height-5))
        path.addLine(to: CGPoint(x: rect.size.width-20, y: rect.size.height))
        path.addLine(to: CGPoint(x: rect.size.width-20-3-3, y: rect.size.height-5))
        path.addLine(to: CGPoint(x:rect.size.width-20, y: rect.size.height-5))
        UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00).setFill()
        path.fill()
    }
    
}

extension Message {
    func getLayout() -> Layout {
        switch self.type {
        case .Received:
            return
                InsetLayout<BubbleViewRecv>(insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15),
                                            alignment: .topTrailing,
                                            sublayout: LabelLayout<UILabel>(text:self.text)) {view in
                                                
                                                view.backgroundColor = .clear
            }
            
        case .Sent:
            return
                InsetLayout<BubbleViewSend>(insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15),
                                            alignment: .topLeading,
                                            sublayout: LabelLayout<UILabel>(text:self.text)) {view in
                                                
                                                view.backgroundColor = .clear
            }
        }
    }
}
