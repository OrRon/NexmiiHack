//
//  MessageLayout.swift
//  NexmiiHack
//
//  Created by Vladimir Kofman on 27/10/2016.
//  Copyright © 2016 Or. All rights reserved.
//

import LayoutKit

extension String {
    func getLayout() -> Layout {
        return
            InsetLayout<UIView>(insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15),
                                sublayout: LabelLayout<UILabel>(text:self))
    }
}
