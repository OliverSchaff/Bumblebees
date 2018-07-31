//
//  AppTableView.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 11.07.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit

class AppTableView: UITableView {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setUpTheming()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpTheming()
    }
}

extension AppTableView: Themed {
    func applyTheme(_ theme: AppTheme) {
        backgroundColor = theme.cellBackgroundColor
    }
}
