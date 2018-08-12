//
//  BeeTimerVC.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 09.06.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

enum ExperimentVCState: ViewControllerState {
    case newObject(ObjectStudied)
    case openWithObject(ObjectStudied)
    case objectChanged(ObjectStudied)
    case SwapNewSubjectSideTo(ExperimentVC.NewSubjectSide)
    case displayHelp
    case displayNewObjectAlert
    case neutralButtons
}

import UIKit
import RealmSwift

class ExperimentVC: UIViewController, Renderer {
    
    enum TappedButton {
        case left
        case right
    }
    
    enum NewSubjectSide {
        case newSubjectIsLeft, newSubjectIsRight
    }
    
    @IBAction func newBee(_ sender: UIBarButtonItem) {
        openNewObjectAlert()
    }
    @IBAction func help(_ sender: UIButton) {
        openHelpAlert()
    }
    @IBOutlet weak var beeNameLabel: UILabel!
    @IBOutlet weak var visitCounter: UILabel!
    @IBOutlet weak var leftButton: ButtonView!
    @IBOutlet weak var rightButton: ButtonView!
    @IBOutlet weak var undoButton: ButtonView!
    @IBOutlet weak var objectImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    lazy var logicController: ExperimentLogicController = {
        return ExperimentLogicController(renderHandler: renderHandler)
    }()
    var object: ObjectStudied!
    var notificationToken: NotificationToken? = nil
    let newObjectAlert: NewObjectAlert = {
        return UIAlertController()
    }()
    let okAlert: OKAlert = {
        return UIAlertController()
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTheming()
        leftButton.setAction(leftAction)
        rightButton.setAction(rightAction)
        undoButton.setAction(undoAction)
        
        logicController.initialSetupForObject(object)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationToken?.invalidate()
        notificationToken = notificationTokenFor(object)
    }
    
    func leftAction() {
        logicController.leftTappedForObject(object)
    }
    
    func rightAction() {
        logicController.rightTappedForObject(object)
    }
    
    func undoAction() {
        logicController.undoTappedForObject(object)
    }
    
    func notificationTokenFor(_ obj: ObjectStudied) -> NotificationToken {
        let notificationToken = obj.observe({[weak self] (change) in
            if let experimentVC = self {
                switch change {
                case .change:
                    experimentVC.logicController.changeForObject(obj)
                case .deleted:
                    print("deleted")
                case .error(let error):
                    print(error.localizedDescription)
                }
            }
        })
        return notificationToken
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }
    
    func render(_ state: ExperimentVCState) {
        switch state {
        case .displayHelp:
            openHelpAlert()
        case .displayNewObjectAlert:
            openNewObjectAlert()
        case .newObject(let obj):
            updateUIForObject(obj)
            resetButtonTitles()
        case .objectChanged(let obj):
            updateUIForObject(obj)
        case .openWithObject(let obj):
            setupUIForFamily(obj.family)
            updateUIForObject(obj)
            resetButtonTitles()
        case .SwapNewSubjectSideTo(let newSubjectSide):
            swapUIFor(newSubjectSide: newSubjectSide)
        case .neutralButtons:
            resetButtonTitles()
        }
    }
    
    
    func setupUIForFamily(_ family: ObjectStudied.Family) {
        navigationItem.rightBarButtonItem?.title = "New \(family.familyName)"
        title = "One \(family.familyName)"
        switch family {
        case .bee:
            objectImageView.image = UIImage(named: "Bee")
            backgroundImageView.image = UIImage(named: "Bee")
        case .flower:
            objectImageView.image = UIImage(named: "Sunflower")
            backgroundImageView.image = UIImage(named: "Sunflower")
        }
    }
    
    func updateUIForObject(_ obj: ObjectStudied) {
        visitCounter.text = "Visits: " + String(obj.observedEvents.count)
        beeNameLabel.text? = obj.name
    }
    
    func resetButtonTitles() {
        leftButton.setTitle("landed")
        rightButton.setTitle("landed")
    }
    
    func swapUIFor(newSubjectSide: NewSubjectSide) {
        let subjectName: String = {
            if object.family == .bee {
                return "flower"
            }
            if object.family == .flower {
                return "bee"
            }
            return ""
        }()
        switch newSubjectSide {
        case .newSubjectIsLeft:
            leftButton.setTitle("new " + subjectName)
            rightButton.setTitle("same " + subjectName)
        case .newSubjectIsRight:
            leftButton.setTitle("same " + subjectName)
            rightButton.setTitle("new " + subjectName)
        }
    }
    
    func openNewObjectAlert() {
        let family = object.family
        let alert = newObjectAlert.nameForObjectOfFamily(family) { (name) in
            let obj = Objects.newObject(name: name, family: family)
            self.object = obj
            self.logicController.newObject(obj)
            self.notificationToken?.invalidate()
            self.notificationToken = self.notificationTokenFor(obj)
        }
        present(alert, animated: true)
    }

    func openHelpAlert() {
        let helpText: String = {
            switch object.family {
            case .bee:
                return "When a bee visits a flower, hit a button. When the bee hops along and stays on the same flower, hit the same button again. If the bee flies to a different flower, hit the other button. If the bee keeps hopping along on this other flower, hit the same button again."
            case .flower:
                return "When the flower is visited by a bee, hit a button. When the same bee hops along on this flower, hit the same button again. When another bee lands on the flower, use the other button. If this second bee keeps hopping along on the flower, hit the same button again."
            }
        }()
        let alert = okAlert.ok(title: "What...?", message: helpText)
        present(alert, animated: true)

    }
    
}

extension ExperimentVC: Themed {
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.backgroundColor
    }
}

