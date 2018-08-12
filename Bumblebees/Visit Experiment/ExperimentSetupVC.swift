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
    
    var objects = Objects()
    var family: ObjectStudied.Family!
    private var objectsStudied: Results<ObjectStudied>? {
        get {
            let predicate = NSPredicate(format: "_family = %@", family.familyName)
            return objects.objectsStudied?.filter(predicate).sorted(byKeyPath: "creationDate", ascending: false)
        }
    }
    private var objectToEdit: ObjectStudied!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTheming()
        objectsTableView.objectsTableViewDelegate = self
        objectsTableView.objects = objectsStudied
        objectsTableView.family = family
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
                flowerVisitsVC.object = objectsStudied![indexOfSelectedObject]
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
        let alert = UIAlertController.nameForObjectOfFamily(family!) { (name) in
            let object = Objects.newObject(name: name, family: self.family)
            self.objectsTableView.selectedObject = object
        }
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

