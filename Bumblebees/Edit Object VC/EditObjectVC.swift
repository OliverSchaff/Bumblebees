//
//  AddBeeVC.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 09.06.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit
import RealmSwift

class EditObjectVC: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var eventsLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var enterCommentLabel: UILabel!
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToExperimentSetupVC", sender: self)
    }
    @IBAction func save(_ sender: UIBarButtonItem) {
        let realm = try! Realm()
        try! realm.write {
            object.name = nameTextField.text ?? ""
            object.comment = commentTextView.text
        }
        performSegue(withIdentifier: "unwindToExperimentSetupVC", sender: self)
    }
    var object: ObjectStudied!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTheming()
        title = "\(object.family.familyName): " + object.name
        hideKeyboardWhenTappedAround()
        nameTextField.delegate = self
        nameTextField.text = object.name
        uuidLabel.text = object.id
        eventsLabel.text = "Number of visits: \(String(object.observedEvents.count))"

        
        commentTextView.delegate = self
        if object.comment == nil || object.comment == "" {
            enterCommentLabel.alpha = 1.0
            commentTextView.text = ""
        } else {
            enterCommentLabel.alpha = 0.0
            commentTextView.text = object.comment
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

extension EditObjectVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditObjectVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        UIView.animate(withDuration: 0.8) {
            self.enterCommentLabel.alpha = 0.0
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            UIView.animate(withDuration: 0.8) {
                self.enterCommentLabel.alpha = 1.0
            }
        }
        return true
    }
}

extension EditObjectVC: Themed {
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.backgroundColor
    }
}


