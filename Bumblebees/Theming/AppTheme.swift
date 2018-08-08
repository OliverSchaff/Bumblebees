//
//  AppTheme.swift
//  Night Mode
//
//  Created by Michael on 01/04/2018.
//  Copyright © 2018 Late Night Swift. All rights reserved.
//

import UIKit

struct AppTheme {
    var name: String
	var statusBarStyle: UIStatusBarStyle
	var barBackgroundColor: UIColor
	var barForegroundColor: UIColor
	var backgroundColor: UIColor
	var textColor: UIColor
    var cellBackgroundColor: UIColor
    var headerFooterTextColor: UIColor
    var cellSelectedColor: UIColor
    var textFieldBackgroundColor: UIColor
    var keyboardAppearance: UIKeyboardAppearance
}

extension AppTheme {
	static let light = AppTheme(
        name: "light",
		statusBarStyle: .`default`,
		barBackgroundColor: .white,
		barForegroundColor: .black,
        backgroundColor: UIColor(white: 0.9, alpha: 1),
		textColor: .darkText,
        cellBackgroundColor: .white,
        headerFooterTextColor:  UIColor(white: 0.2, alpha: 1),
        cellSelectedColor: .lightGreenDay,
        textFieldBackgroundColor: .white,
        keyboardAppearance: .light
	)

	static let dark = AppTheme(
        name: "dark",
		statusBarStyle: .lightContent,
		barBackgroundColor: UIColor(white: 0, alpha: 1),
		barForegroundColor: .white,
		backgroundColor: UIColor(white: 0.1, alpha: 1),
		textColor: .lightText,
        cellBackgroundColor: UIColor(white: 0.2, alpha: 1),
        headerFooterTextColor:  UIColor(white: 0.8, alpha: 1),
        cellSelectedColor: .darkGreenNight,
        textFieldBackgroundColor: UIColor(white: 0.3, alpha: 1),
        keyboardAppearance: .dark
	)
}
