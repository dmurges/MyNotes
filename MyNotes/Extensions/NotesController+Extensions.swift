
import UIKit

extension NotesController: CreateNoteControllerDelegate {
    
    
    
    func addedNote(note: Note) {
        //        notes.append(note)
        notes.insert(note, at: 0)
        let newIndexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        notes.forEach { (note) in
            print(note)
        }
        
    }
    
    func editedNote(note: Note){
        
        let row = notes.index(of: note)
        notes.remove(at: row!)
        notes.insert(note, at: 0)
        tableView.reloadData()
        
        notes.forEach { (note) in
            print(note)
        }
    }
}

