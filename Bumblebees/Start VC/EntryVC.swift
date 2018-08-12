//
//  ExperimentSetupVC.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 10.06.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit
import RealmSwift

class EntryVC: UITableViewController {
    
    @IBAction func unwindToExperimentSetupVC(_ sender: UIStoryboardSegue) {
    }
    @IBAction func exportBees(_ sender: UIButton) {
        export(objects)
    }
    @IBAction func exportLabBook(_ sender: UIButton) {
        export(labBook)
    }
    @IBAction func nightModeChanged(_ sender: UISwitch) {
        themeProvider.currentTheme = sender.isOn ? AppTheme.dark : AppTheme.light
        appDelegate.nightMode = sender.isOn
    }
    @IBOutlet weak var nightModeSwitch: UISwitch!
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var labBook: LabBook {
        get {
            return LabBook.open() ?? LabBook.makeNew()
        }
    }
    var objects = Objects()
    var objectsStudied: Results<ObjectStudied>? {
        get {
            return objects.objectsStudied
        }
    }
    let okAlert: OKAlert = {
        return UIAlertController()
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTheming()
        nightModeSwitch.setOn(appDelegate.nightMode, animated: false)
    }
    
    func export<T: JSONExportable>(_ data: T) {
        data.exportAsJSON { (result) in
            switch result {
            case .success:
                let alert = okAlert.ok(title: "Success", message: "\(data.displayText) has been exported.")
                self.present(alert, animated: true)
            case .error(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "oneBeeSetup":
            let experimentSetupVC = segue.destination as! ExperimentSetupVC
            experimentSetupVC.objects = objects
            experimentSetupVC.family = ObjectStudied.Family.bee
        case "oneFlowerSetup":
            let experimentSetupVC = segue.destination as! ExperimentSetupVC
            experimentSetupVC.objects = objects
            experimentSetupVC.family = ObjectStudied.Family.flower
        case "showAddLabBookEntry":
            let navCon = segue.destination as! UINavigationController
            let addEntryVC = navCon.topViewController as! AddLabBookEntryVC
            addEntryVC.labBook = labBook
        default:
            assert(false, "unknown segue")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EntryVC: Themed {
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.backgroundColor
    }
}

