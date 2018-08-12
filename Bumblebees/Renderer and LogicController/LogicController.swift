//
//  LogicController.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 28.07.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

/// A class that computes view controller states and requests the rendering of these states with its requestRenderingOfState(_ state:) function
protocol LogicController {
    associatedtype State: ViewControllerState
    var renderHandler: (State)->() {get }
    init(renderHandler: @escaping (State)->())
    func requestRenderingOfState(_ state: State)
}

extension LogicController {
    func requestRenderingOfState(_ state: State) {
        renderHandler(state)
    }
}
