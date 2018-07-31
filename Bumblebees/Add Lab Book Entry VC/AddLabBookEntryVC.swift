//
//  AddLabBookEntryVC.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 22.06.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit
import RealmSwift

class AddLabBookEntryVC: UITableViewController {

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToExperimentSetupVC", sender: self)
    }
    @IBAction func save(_ sender: UIBarButtonItem) {
        let entry = LabBookEntry()
        entry.date = Date()
        entry.text = entryTextView.text
        let realm = try! Realm()
        try! realm.write {
            labBook.entries.append(entry)
        }
        performSegue(withIdentifier: "unwindToExperimentSetupVC", sender: self)
    }
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var enterTextLabel: UILabel!

    var labBook: LabBook!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTheming()
        hideKeyboardWhenTappedAround()
        entryTextView.text = ""
        entryTextView.delegate = self
        enterTextLabel.alpha = 1.0
    }
}

extension AddLabBookEntryVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        UIView.animate(withDuration: 0.8) {
            self.enterTextLabel.alpha = 0.0
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            UIView.animate(withDuration: 0.8) {
                self.enterTextLabel.alpha = 1.0
            }
        }
        return true
    }
}

extension AddLabBookEntryVC: Themed {
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.backgroundColor
    }
}


