//
//  ViewController.swift
//  DreamLister
//
//  Created by Didik Ismawanto on 2/18/17.
//  Copyright © 2017 Didik Ismawanto. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var fetchResultController: NSFetchedResultsController<Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        attemptRequest()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath){
        let item = fetchResultController.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = fetchResultController.fetchedObjects, objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailVC" {
            if let destination = segue.destination as? ItemDetailVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchResultController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func attemptRequest(){
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        
        switch segment.selectedSegmentIndex {
        case 0:
            fetchRequest.sortDescriptors = [dateSort]
            break
        case 1:
            fetchRequest.sortDescriptors = [priceSort]
            break
        case 2:
            fetchRequest.sortDescriptors = [titleSort]
            break
        default:
            break
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        fetchResultController = controller
        
        do {
            try controller.performFetch()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type){
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        attemptRequest()
        tableView.reloadData()
    }
    func generateTestData(){
        let item = Item(context: context)
        item.title = "Macbook Pro"
        item.price = 1800
        item.detail = "I need to upgrade my Macbook Air."
        item.created = NSDate()
        
        let item2 = Item(context: context)
        item2.title = "Bose Headphone"
        item2.price = 300
        item2.detail = "I just hear this headphone vendor"
        item2.created = NSDate()
        
        let item3 = Item(context: context)
        item3.title = "Pajero Sport"
        item3.price = 47000
        item3.detail = "I think I need this one to get girlfriend."
        item3.created = NSDate()
        
        ad.saveContext()
        
    }

}

