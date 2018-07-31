//
//  AppLabel.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 12.07.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit

class AppLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTheming()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpTheming()
    }
    
}

extension AppLabel: Themed {
    
    func applyTheme(_ theme: AppTheme) {
        textColor = theme.textColor
        backgroundColor = .clear
    }
}
