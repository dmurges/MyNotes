

import UIKit
import CoreData


class TestController: UITableViewController, NSFetchedResultsControllerDelegate  {
    
    
    var notes = [Note]()
    let cellId = "cellId"
    
    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)
        ]
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        }catch let err {
            print(err)
        }
        
        return frc
    }()
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.register(NoteCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.title = "My Notes"
        
        tableView.tableFooterView = UIView(frame: .zero)
        view.backgroundColor = UIColor.flatBlue
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-1"), style: .plain, target: self, action: #selector(handleAdd))
        tableView.backgroundColor = UIColor.flatBlueDark
        
    }
    
    @objc private func handleReset () {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        do {
            let fetchedNotes = try context.fetch(request)
            fetchedNotes.forEach({ (note) in
                context.delete(note)
            })
            
            try context.save()
        }catch let fetchErr {
            print("Couldn't fetch notes", fetchErr)
        }
        
    }
    
    @objc private func handleAdd() {
        let createController = CreateNoteController()
        let navController = UINavigationController(rootViewController: createController)
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteCell
        
        let note = fetchedResultsController.object(at: indexPath)
        cell.note = note
        
        
        cell.backgroundColor = UIColor.flatPlumDark
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editNoteController = CreateNoteController()
        
        editNoteController.note = fetchedResultsController.object(at: indexPath)
        let navController = CustomNavigationController(rootViewController: editNoteController)
        present(navController, animated: true, completion: nil)
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            
            let request: NSFetchRequest<Note> = Note.fetchRequest()
            
            
            //            let note = self.fetchedResultsController.object(at: indexPath)
            //            print("Attempting to delete note:", note.topic ?? "")
            
            //self.notes.remove(at: indexPath.row)
            
            
            
            let context = CoreDataManager.shared.persistentContainer.viewContext
            
            
            
            
            do {
                let fetchedNotes = try context.fetch(request)
                let note = fetchedNotes[indexPath.row]
                let row = fetchedNotes.index(of: note)
                let newIndexPath = IndexPath(row: row!, section: 0)
                tableView.reloadRows(at: [newIndexPath], with: .left)
                context.delete(note)
                try context.save()
                
            } catch let saveErr {
                print("Failed to delete note:", saveErr)
            }
        }
        
        deleteAction.backgroundColor = UIColor.flatRed
        return [deleteAction]
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .middle)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .middle)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .middle)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .left)
        case .update:
            tableView.reloadRows(at: [newIndexPath!], with: .middle)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    
}
