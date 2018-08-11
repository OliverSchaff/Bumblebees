//
//  FlowerVisitsSetupVC2.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 17.07.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit
import RealmSwift


class ExperimentSetupVC: UITableViewController {

    @IBAction func unwindToExperimentSetupVC(_ sender: UIStoryboardSegue) {
    }
    @IBOutlet weak var objectsTableView: ObjectsTableView!
    @IBAction func newObject(_ sender: UIBarButtonItem) {
        openNewObjectAlert()
    }
    @IBAction func startExperiment(_ sender: UIButton) {
        performSegue(withIdentifier: "startExperiment", sender: self)
    }
    
    
    var objects: Results<ObjectStudied>?
    var objectToEdit: ObjectStudied!
    var family: ObjectStudied.Family!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTheming()
//        let realm = try! Realm()
//        let predicate = NSPredicate(format: "_family = %@", family.familyName)
//        objects = realm.objects(ObjectStudied.self).filter(predicate).sorted(byKeyPath: "name")
        objectsTableView.objectsTableViewDelegate = self
        objectsTableView.objects = objects
        objectsTableView.family = family
        objectsTableView.accessibilityIdentifier = "objectsTable"
        objectsTableView.isAccessibilityElement = true
        navigationItem.rightBarButtonItem?.title = "New \(family.familyName)"
        title = "One \(family.familyName) Setup"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "startExperiment":
            let flowerVisitsVC = segue.destination as! ExperimentVC
            if let indexOfSelectedObject = objectsTableView.indexPathForSelectedRow?.row {
                flowerVisitsVC.object = objects![indexOfSelectedObject]
            } else {
                openSelectObjectAlert()
            }
        case "showEditObject":
            let navCon = segue.destination as! UINavigationController
            let editObjectVC = navCon.topViewController as! EditObjectVC
            editObjectVC.object = objectToEdit
        default:
            assert(false, "unknown segue")
        }
    }
    
    func openNewObjectAlert() {
        let realm = try! Realm()
        var speciesData: NameProvider!
        switch family! {
        case .bee:
            speciesData = BeeData()
        case .flower:
            speciesData = FlowerData()
        }
        let alert = UIAlertController(title: "New \(family.familyName)",
                                      message: "Add name of \(family.familyName.lowercased())",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameOfObject = textField.text else {
                                                return
                                        }
                                        let object = ObjectStudied(name: nameOfObject, family: self.family)
                                        try! realm.write {
                                            realm.add(object)
                                        }
                                        self.objectsTableView.selectedObject = object
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { (textField) in
            textField.text = speciesData.name
            textField.placeholder = "Enter name"
            textField.clearButtonMode = .always
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    func openSelectObjectAlert() {
        let alert = UIAlertController.ok(title: "Select \(family.familyName)", message: "Please select a \(family.familyName.lowercased()) for the experiment.")
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return family.familyName + "s"
        }
        return nil
    }

}

extension ExperimentSetupVC: ObjectsTableViewDelegate {
    
    func didTapAccessoryForObject(_ object: ObjectStudied) {
        objectToEdit = object
        performSegue(withIdentifier: "showEditObject", sender: self)
    }
}

extension ExperimentSetupVC: Themed {
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.backgroundColor
    }
}

