//
//  Renderer.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 28.07.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

/// A Type that represents states of a view Controller. Typically this should be an Enum
protocol ViewControllerState {}

/// A Class that can render states with its render(state) function. It uses the help of a LogicController to compute the states
protocol Renderer: class {
    associatedtype LC: LogicController
    associatedtype State: ViewControllerState
    var logicController: LC {get}
    var renderHandler: (State)->() {get}
    func render(_ state: State)
}

extension Renderer {
    var renderHandler: (State)->() {
        get {
            return {[weak self] (state) in self?.render(state)}
        }
    }
}
