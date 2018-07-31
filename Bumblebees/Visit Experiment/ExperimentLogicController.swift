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
    
    func newObject(_ object: ObjectStudied) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
        requestRenderingOfState(.newObject(object))
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
        guard obj.observedEvents.count > minEventIndex else { return }
        let realm = try! Realm()
        try! realm.write {
            guard let lastVisit = obj.observedEvents.last else { return }
            let uiState = uiStateStack.pop()
            newSubjectSide = uiState.newSubjectSideBeforeEvent
            lastTapped = uiState.lastTappedBeforeEvent
            realm.delete(lastVisit)
        }
    }
    
    func initialSetupForObject(_ obj: ObjectStudied) {
        requestRenderingOfState(.openWithObject(obj))
        minEventIndex = obj.observedEvents.count
    }
    
    // MARK: - Helper code
    
    func addEventForObject(_ obj: ObjectStudied, newSubject: Bool) {
        let event = Event()
        event.date = Date()
        if newSubject || obj.observedEvents.isEmpty {
            event.index = lastFlowerIndexOfObject(obj) + 1
        } else {
            event.index = lastFlowerIndexOfObject(obj)
        }
        uiStateStack.push(UIState(event: event, newSubjectSideBeforeEvent: newSubjectSide, lastTappedBeforeEvent: lastTapped))
        let realm = try! Realm()
        try! realm.write {
            obj.observedEvents.append(event)
        }
    }
    
    
    func lastFlowerIndexOfObject(_ obj: ObjectStudied) -> Int {
        if let lastVisit = obj.observedEvents.last {
            return lastVisit.index
        } else {
            return 0
        }
    }

}
