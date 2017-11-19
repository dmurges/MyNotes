

import UIKit
import CoreData



protocol CreateNoteControllerDelegate {
    func addedNote(note: Note)
    func editedNote(note: Note)
}

class CreateNoteController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    var delegate: CreateNoteControllerDelegate?
    
    var note: Note? {
        didSet {
            topicTextField.text = note?.topic
            
            if let imageData = note?.imageData {
                photoView.image = UIImage(data: imageData)
                circularImage()
                
            }
            
            noteText.text = note?.noteDescription
        }
    }
    
    let topicLabel: UILabel = {
        let label = UILabel()
        label.text = "Topic"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let topicTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter Topic"
        textfield.font = UIFont(name: "Helvetica Neue", size: 16)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    
    
    lazy var photoView: UIImageView = {
        let photo = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        photo.isUserInteractionEnabled = true
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage)))
        return photo
    }()
    
    lazy var noteText: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.boldSystemFont(ofSize: 20)
        text.layer.cornerRadius = 20
        text.layer.masksToBounds = true
        return text
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        view.backgroundColor = .flatBlue
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissController))
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.title = "Create Note"
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.leftBarButtonItem = backButton
        view.backgroundColor = UIColor.flatPlum
        setupUI()
    }
    
    
    @objc func handleSave () {
        if note == nil {
            createNote()
        }else {
            editNote()
        }
    }
    
    private func topicMissing() {
        let alertController = UIAlertController(title: "Empty Topic", message: "You have not chosen a topic", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func editNote() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let timestamp = Int(NSDate().timeIntervalSince1970)
        
        if (topicTextField.text?.isEmpty)! {
            topicMissing()
            return
        }
        
        note?.topic = topicTextField.text
        note?.noteDescription = noteText.text
        note?.timestamp = Double(timestamp)
        
        
        if let noteImage = photoView.image {
            let imageData = UIImageJPEGRepresentation(noteImage, 0.8)
            note?.imageData = imageData
        }
        
        do {
            try context.save()
            
            dismiss(animated: true, completion: {
                self.delegate?.editedNote(note: self.note!)
            })
        }catch let editErr {
            print("Couldn't edit note", editErr)
        }
    }
    
    
    private func createNote() {
        print("tried to save note")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context)
        
        if (topicTextField.text?.isEmpty)! {
            topicMissing()
            return
        }
        
        note.setValue(topicTextField.text, forKey: "topic")
        note.setValue(noteText.text, forKey: "noteDescription")
        note.setValue(timestamp, forKey: "timestamp")
        
        
        if let noteImage = photoView.image {
            let imageData = UIImageJPEGRepresentation(noteImage, 0.8)
            note.setValue(imageData, forKey: "imageData")
        }
        
        
        do {
            try context.save()
            dismiss(animated: true, completion: {
                self.delegate?.addedNote(note: note as! Note)
            })
        }catch let err {
            print("failed to save note:", err)
        }
    }
    
    @objc func pickImage() {
        print("picked an image")
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            photoView.image = editedImage
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoView.image = originalImage
        }
        
        circularImage()
        dismiss(animated: true, completion: nil)
    }
    
    func circularImage () {
        photoView.layer.cornerRadius = photoView.frame.width / 2
        photoView.clipsToBounds = true
        photoView.layer.borderColor = UIColor.flatBlue.cgColor
        photoView.layer.borderWidth = 2
    }
    
    func setupUI() {
        let lightBlueBackground = UIView()
        lightBlueBackground.backgroundColor = UIColor.flatMagenta
        lightBlueBackground.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(lightBlueBackground)
        lightBlueBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackground.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        lightBlueBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lightBlueBackground.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        view.addSubview(photoView)
        photoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        photoView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        view.addSubview(topicLabel)
        topicLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor).isActive = true
        topicLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        topicLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        topicLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(topicTextField)
        topicTextField.topAnchor.constraint(equalTo: photoView.bottomAnchor).isActive = true
        topicTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        topicTextField.leftAnchor.constraint(equalTo: topicLabel.rightAnchor).isActive = true
        topicTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        view.addSubview(noteText)
        noteText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        noteText.topAnchor.constraint(equalTo: lightBlueBackground.bottomAnchor, constant: 18).isActive = true
        noteText.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        noteText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -18).isActive = true
        
        
    }
    
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}
