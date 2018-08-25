//
//  AppAlertLabel.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 25.08.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit

class AppAlertLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTheming()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpTheming()
    }
    
}

extension AppAlertLabel: Themed {
    
    func applyTheme(_ theme: AppTheme) {
        textColor = theme.alertTextColor
        backgroundColor = .clear
    }
}
