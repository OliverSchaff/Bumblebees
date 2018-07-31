//
//  Result.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 22.07.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case error(Error)
}
