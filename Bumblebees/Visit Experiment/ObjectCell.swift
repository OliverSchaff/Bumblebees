//
//  BeeCell.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 10.06.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit

class ObjectCell: AppTableViewCell {
    
    @IBOutlet weak var objectNameLabel: UILabel!

    func configureWith(_ object: ObjectStudied) {
        objectNameLabel.text = object.name
    }

}
