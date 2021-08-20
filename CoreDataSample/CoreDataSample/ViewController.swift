//
//  ViewController.swift
//  CoreDataSample
//
//  Created by hanwe on 2021/08/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var cnt: Int = 0
    
    struct Person {
        var name: String
        var number: Int
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func add(_ sender: Any) {
        let hanwe: Person = Person(name: "하이\(self.cnt)", number: cnt)
        cnt += 1
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
//        if let entity = entity {
//            let person = NSManagedObject(entity: entity, insertInto: context)
//            person.setValue(hanwe.name, forKey: "name")
//            person.setValue(hanwe.number, forKey: "number")
//
//            do {
//                try context.save()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
        let coreDataManager = PersonPersistenceManager.shared
        coreDataManager.insert(insertedObject: hanwe)

    }
    
    func fetchContact() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        do {
//            let contact = try context.fetch(Contact.fetchRequest()) as! [Contact]
//            contact.forEach {
//                print($0.name)
//                print($0.number)
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
        
//        let coreDataManager = PersonPersistenceManager.shared
//        coreDataManager.fetch(request: <#T##NSFetchRequest<T>#>)
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        let contact = PersonPersistenceManager.shared.fetch(request: request)
        contact.forEach {
            print($0.name ?? "_")
            print($0.number)
        }
    }
    
    @IBAction func show(_ sender: Any) {
        fetchContact()
    }
    
}

