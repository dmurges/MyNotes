//
//  NotesController.swift
//  MyNotes
//
//  Created by David Murges on 6/11/17.
//  Copyright © 2017 David Murges. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class NotesController: UITableViewController {
    
    
    
    let cellId = "cellId"
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.notes = CoreDataManager.shared.fetchNotes()
        self.notes.sort { (note1, note2) -> Bool in
            
            return note1.timestamp > note2.timestamp
        }
        
        
        tableView.register(NoteCell.self, forCellReuseIdentifier: cellId)
        
        tableView.tableFooterView = UIView(frame: .zero)
        view.backgroundColor = UIColor.flatPlum
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-1"), style: .plain, target: self, action: #selector(handleAdd))
        self.navigationItem.title = "My Notes"
        
        
    }
    
    
    
    @objc func handleAdd() {
        let createController = CreateNoteController()
        let navController = UINavigationController(rootViewController: createController)
        createController.delegate = self
        present(navController, animated: true, completion: nil)
    }
    
    @objc private func handleReset(){
        
        let alertController = UIAlertController(title: "Delete Notes", message: "Are you sure you want to delete all your notes?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            self.Resetting()
        }))
        present(alertController, animated: true, completion: nil)
        
    }
    
    private func Resetting () {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let batchRequest = NSBatchDeleteRequest(fetchRequest: Note.fetchRequest())
        
        do {
            try context.execute(batchRequest)
            var indexPathsToRemove = [IndexPath]()
            
            for (index,_) in notes.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            notes.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
            
            
        }catch let delErr {
            print("Failed to delete objects:",delErr)
        }
    }
    
}



