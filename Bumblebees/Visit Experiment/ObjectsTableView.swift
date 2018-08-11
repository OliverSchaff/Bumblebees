//
//  BeesTableView.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 23.06.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit
import RealmSwift

class ObjectsTableView: AppTableView, UITableViewDelegate, UITableViewDataSource {
    
    var family: ObjectStudied.Family!
    var objects: Results<ObjectStudied>? {
        didSet {
            
            if let objects = objects {
                
                notificationToken = objects._observe({[weak self] (changes: RealmCollectionChange) in
                    guard let tableView = self else { return }
                    
                    if objects.count == 0 {
                        let noObjectsLabel = AppLabel(frame: tableView.frame)
                        noObjectsLabel.numberOfLines = 2
                        noObjectsLabel.text = "Please add a \(tableView.family.familyName.lowercased()) \n with the New \(tableView.family.familyName) button"
                        noObjectsLabel.textAlignment = .center
                        noObjectsLabel.alpha = 0.0
                        tableView.tableHeaderView = noObjectsLabel
                        UIView.animate(withDuration: 0.7, animations: {
                            tableView.tableHeaderView?.alpha = 1.0
                        })
                    } else {
                        tableView.tableHeaderView = nil
                    }
                    
                    switch changes {
                    case .initial:
                        tableView.reloadData()
                    case .update(_, let deletions, let insertions, let modifications):
                        // Query results have changed, so apply them to the UITableView
                        
                        if !deletions.isEmpty {
                            let indices = deletions.map({ IndexPath(row: $0, section: 0)})
                            tableView.deleteRows(at: indices, with: .automatic)

                        }
                        
                        if !insertions.isEmpty {
                            let indices = insertions.map({ IndexPath(row: $0, section: 0)})
                            tableView.insertRows(at: indices, with: .automatic)
                            for index in indices {
                                tableView.selectRow(at: index, animated: true, scrollPosition: .middle)
                                self?.selectedObject = objects[index.row]
                            }
                            
                        }
                        
                        if !modifications.isEmpty {
                            let selectedCellIndex = self?.indexPathForSelectedRow
                            let indices = modifications.map({ IndexPath(row: $0, section: 0)})
                            tableView.reloadRows(at: indices, with: .automatic)
                            for index in indices {
                                if index == selectedCellIndex {
                                    tableView.selectRow(at: index, animated: false, scrollPosition: .none)
                                    self?.selectedObject = objects[index.row]
                                }
                            }
                            
                        }
                        
                    case .error(let error):
                        // An error occurred while opening the Realm file on the background worker thread
                        fatalError("\(error)")
                    }
                })
            }
        }
    }
    var selectedObject: ObjectStudied?
    var notificationToken: NotificationToken? = nil
    weak var objectsTableViewDelegate: ObjectsTableViewDelegate?
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func awakeFromNib() {
        delegate = self
        dataSource = self
        tableFooterView = UIView()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let objects = objects else { return 0}
        return objects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let object = objects?[indexPath.row] else { return UITableViewCell()}
        
        let objectCell = tableView.dequeueReusableCell(withIdentifier: "objectCell", for: indexPath) as! ObjectCell
        objectCell.configureWith(object)
        return objectCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bee = objects?[indexPath.row] else { return }
        selectedObject = bee
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let object = objects?[indexPath.row] else { return }
        objectsTableViewDelegate?.didTapAccessoryForObject(object)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        selectedObject = nil
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let object = objects?[indexPath.row] {
                object.delete()
            }
        }
    }

}
