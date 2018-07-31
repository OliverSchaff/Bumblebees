//
//  AppTableViewCell.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 11.07.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit

class AppTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpTheming()
        let bgView = UIView()
        bgView.backgroundColor = themeProvider.currentTheme.cellSelectedColor
        selectedBackgroundView = bgView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpTheming()
        let bgView = UIView()
        bgView.backgroundColor = themeProvider.currentTheme.cellSelectedColor
        selectedBackgroundView = bgView
    }
}

extension AppTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        selectedBackgroundView?.backgroundColor = theme.cellSelectedColor
        backgroundColor = theme.cellBackgroundColor
    }
}
