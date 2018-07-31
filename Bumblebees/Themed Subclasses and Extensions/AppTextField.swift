//
//  AppTextField.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 13.07.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit

class AppTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTheming()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpTheming()
    }
}

extension AppTextField: Themed {
    
    func applyTheme(_ theme: AppTheme) {
        textColor = theme.textColor
        backgroundColor = theme.textFieldBackgroundColor
        keyboardAppearance = theme.keyboardAppearance
    }
}
