//
//  AppMalert.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 24.08.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import Foundation
import UIKit

class AppMalert: Malert {
    
    override init(title: String? = nil, customView: UIView? = nil, tapToDismiss: Bool = true, dismissOnActionTapped: Bool = true) {
        super.init(title: title, customView: customView, tapToDismiss: tapToDismiss, dismissOnActionTapped: dismissOnActionTapped)
        animationType = .fadeIn
        margin = 16
        buttonsAxis = .horizontal
        cornerRadius = 16
        setUpTheming()
    }
}

extension AppMalert: Themed {
    func applyTheme(_ theme: AppTheme) {
        backgroundColor = theme.alertBackgroundColor
        separetorColor = theme.alertSeparatorColor
    }
}

extension AppMalert {
    static func ok(title: String, message: String) -> AppMalert {
        let okView = OKView.instantiateFromNib()
        okView.populate(title: title, message: message)
        let alert = AppMalert(customView: okView)
        let action = MalertAction(title: "OK")
        alert.addAction(action)
        return alert
    }
    
    static func nameForObjectOfFamily(_ family: ObjectStudied.Family, callback: @escaping (String)->()) -> AppMalert {
        var objectData: NameProvider!
        switch family {
        case .bee:
            objectData = BeeData()
        case .flower:
            objectData = FlowerData()
        }
        let newObjectView = NewObjectView.instantiateFromNib()
        newObjectView.populate(title: "New \(family.familyName)", objectName: objectData.name)
        let alert = AppMalert(customView: newObjectView, tapToDismiss: false, dismissOnActionTapped: true)
        let cancelAction = MalertAction(title: "Cancel")
        alert.addAction(cancelAction)

        let saveAction = MalertAction(title: "Save") {
            guard let nameOfObject = newObjectView.newNameTextField.text else { return }
            callback(nameOfObject)
        }
        alert.addAction(saveAction)
        return alert
    }
}
