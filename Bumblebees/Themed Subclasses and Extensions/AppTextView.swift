//
//  AppTextView.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 13.07.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit

class AppTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUpTheming()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpTheming()
    }
}

extension AppTextView: Themed {
    
    func applyTheme(_ theme: AppTheme) {
        textColor = theme.textColor
        backgroundColor = theme.cellBackgroundColor
        keyboardAppearance = theme.keyboardAppearance
    }
}
