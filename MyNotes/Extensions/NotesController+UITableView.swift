
import UIKit


extension NotesController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteCell
        
        
        let note = notes[indexPath.row]
        cell.note = note
        
        cell.backgroundColor = UIColor.flatMagenta
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editNoteController = CreateNoteController()
        editNoteController.delegate = self
        editNoteController.note = notes[indexPath.row]
        let navController = CustomNavigationController(rootViewController: editNoteController)
        present(navController, animated: true, completion: nil)
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let note = self.notes[indexPath.row]
            print("Attempting to delete note:", note.topic ?? "")
            
            self.notes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let context = CoreDataManager.shared.persistentContainer.viewContext
            
            context.delete(note)
            
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to delete note:", saveErr)
            }
        }
        
        deleteAction.backgroundColor = UIColor.flatRed
        return [deleteAction]
    }
}
