//
//  ScheduleTableViewController.swift
//  EverywhereFitness
//
//  Created by Kenneth Jones on 1/22/21.
//

import UIKit
import CoreData

class ScheduleTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedResultsController: NSFetchedResultsController<FitnessClass> = {
        let fetchRequest: NSFetchRequest<FitnessClass> = FitnessClass.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error fetching Fitness Classes: \(error)")
        }
        
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .fitnessClassCreated, object: nil)
    }
    
    @IBAction func refreshData(_ sender: Any) {
        FitnessClassController.sharedInstance.fetchAll() { (_) in
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc func updateViews() {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BigClassTableViewCell.reuseIdentifier, for: indexPath) as? BigClassTableViewCell else {
            fatalError("Can't dequeue cell of type \(BigClassTableViewCell.reuseIdentifier)")
        }
        
        cell.fitnessClass = fetchedResultsController.object(at: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let fitnessClass = fetchedResultsController.object(at: indexPath)
            let moc = CoreDataStack.shared.mainContext
            moc.delete(fitnessClass)
            FitnessClassController.sharedInstance.deleteClass(fitnessClass) { (result) in
                DispatchQueue.main.async {
                    do {
                        try moc.save()
                        tableView.reloadData()
                    } catch {
                        moc.reset()
                        NSLog("Error saving managed object context: \(error)")
                    }
                }
            }
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                  let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
