//
//  ViewController.swift
//  Core_Data-2
//
//  Created by iim jobs on 26/02/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var people: [NSManagedObject] = []
    
    var managedObjectContext: NSManagedObjectContext?
    
    @IBOutlet weak var tableView: UITableView!
    
// MARK: - Add entires on button click
    @IBAction func addTask(_ sender: Any) {
        let alert = UIAlertController(title: "New Name", message: "Add new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
                                          
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else {
                return
            }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
    
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

    func save(name: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedObjectContext!)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedObjectContext!)
        
        person.setValue(name, forKeyPath: "name")
        person.setValue(Date().toString(dateFormat: "MM-dd HH:mm:ss"), forKeyPath: "date")
        
        do {
            try managedObjectContext?.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try managedObjectContext!.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "List"
    }
}

// MARK:- TableView DataSource
extension ViewController: UITableViewDataSource {
  
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
  
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let person = people[indexPath.row]
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        cell.detailTextLabel?.text = person.value(forKeyPath: "date") as? String
        return cell
    }
}

// MARK:- ToString for Date()
extension Date {
    func toString(dateFormat format  : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
