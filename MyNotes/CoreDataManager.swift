

import UIKit
import CoreData

struct CoreDataManager {
    
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyNotesModels")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let err = error {
                fatalError("Failed to load store: \(err)")
            }
        })
        return container
    }()
    
    func fetchNotes() -> [Note] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        
        do {
            
            let notes = try context.fetch(fetchRequest)
            return notes
            
        }catch let fetchErr {
            print("Failed to fetch notes:", fetchErr)
            return []
        }
        
    }
    
}
