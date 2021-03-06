//
//  ExperimentLogicController.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 27.07.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//


import RealmSwift

class ExperimentLogicController: LogicController {
    
    struct UIState {
        let event: Event
        let newSubjectSideBeforeEvent: ExperimentVC.NewSubjectSide?
        let lastTappedBeforeEvent: ExperimentVC.TappedButton?
    }

    // MARK: - Logic Controller Protocol
    
    typealias State = ExperimentVCState
    internal let renderHandler: (State) -> ()
    
    required init(renderHandler: @escaping (State)->()) {
        self.renderHandler = renderHandler
    }

    // MARK: - properties
    
    var newSubjectSide: ExperimentVC.NewSubjectSide? = nil {
        didSet {
            if let newSubjectSide = newSubjectSide {
                requestRenderingOfState(.SwapNewSubjectSideTo(newSubjectSide))
            } else {
                requestRenderingOfState(.neutralButtons)
            }
        }
    }
    var lastTapped: ExperimentVC.TappedButton?
    var minEventIndex: Int = 0
    var uiStateStack = Stack<UIState>()
    
    // MARK: - event handling
    
    func newObject(_ obj: ObjectStudied) {
        requestRenderingOfState(.newObject(obj))
    }
    
    func changeForObject(_ obj: ObjectStudied) {
        requestRenderingOfState(.objectChanged(obj))
    }
    
    func leftTappedForObject(_ obj: ObjectStudied) {
        if lastTapped == .left {
            addEventForObject(obj, newSubject: false)
        } else {
            addEventForObject(obj, newSubject: true)
            newSubjectSide = .newSubjectIsRight
        }
        lastTapped = .left
    }
    
    func rightTappedForObject(_ obj: ObjectStudied) {
        if lastTapped == .right {
            addEventForObject(obj, newSubject: false)
        } else {
            addEventForObject(obj, newSubject: true)
            newSubjectSide = .newSubjectIsLeft
        }
        lastTapped = .right
    }
    
    func undoTappedForObject(_ obj: ObjectStudied) {
        guard obj.observedEvents.count > minEventIndex, let lastVisit = obj.observedEvents.last else { return }
        let uiState = uiStateStack.pop()
        newSubjectSide = uiState.newSubjectSideBeforeEvent
        lastTapped = uiState.lastTappedBeforeEvent
        lastVisit.delete()
    }
    
    func initialSetupForObject(_ obj: ObjectStudied) {
        requestRenderingOfState(.openWithObject(obj))
        minEventIndex = obj.observedEvents.count
    }
    
    func addEventForObject(_ obj: ObjectStudied, newSubject: Bool) {
        let event = obj.newEvent(newSubject: newSubject)
        uiStateStack.push(UIState(event: event, newSubjectSideBeforeEvent: newSubjectSide, lastTappedBeforeEvent: lastTapped))
    }
    
}
