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
        exportExperimentData()
    }
    @IBAction func exportLabBook(_ sender: UIButton) {
        exportLabBook()
    }
    @IBAction func nightModeChanged(_ sender: UISwitch) {
        themeProvider.currentTheme = sender.isOn ? AppTheme.dark : AppTheme.light
        appDelegate.nightMode = sender.isOn
    }
    @IBOutlet weak var nightModeSwitch: UISwitch!
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var labBook = LabBook()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTheming()
        nightModeSwitch.setOn(appDelegate.nightMode, animated: false)
        let realm = try! Realm()
        labBook = realm.object(ofType: LabBook.self, forPrimaryKey: "myBeesExperimentLabBook") ?? LabBook()
        try! realm.write {
            realm.add(labBook)
        }
    }
    
    func exportExperimentData() {
        let realm = try! Realm()
        let objects = realm.objects(ObjectStudied.self).sorted(byKeyPath: "_family")
        var objectsArray = [ObjectStudied]()
        for object in objects {
            objectsArray.append(object)
        }
        do {
            let fileURL = try DataExportHelpers.generateFileURLForBaseString("ExperimentData", withExtension: "json")
            DataExportHelpers.exportArray(array: objectsArray, to: fileURL) { (result) in
                switch result {
                case .success:
                    let alert = UIAlertController.ok(title: "Success", message: "Bees have been exported.")
                    self.present(alert, animated: true)
                case .error(let error):
                    print(error)
                }

            }
        } catch {
            print(error)
        }
    }
    
    func exportLabBook() {
        do {
            let fileURL = try DataExportHelpers.generateFileURLForBaseString("LabBook", withExtension: "json")
            labBook.exportTo(fileURL: fileURL) { (result) in
                switch result {
                case .success:
                    let alert = UIAlertController.ok(title: "Success", message: "Lab book has been exported.")
                    self.present(alert, animated: true)
                case .error(let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "oneBeeSetup":
            let experimentSetupVC = segue.destination as! ExperimentSetupVC
            experimentSetupVC.family = ObjectStudied.Family.bee
        case "oneFlowerSetup":
            let experimentSetupVC = segue.destination as! ExperimentSetupVC
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

