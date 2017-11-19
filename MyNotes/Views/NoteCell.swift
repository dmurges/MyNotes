
import UIKit

class NoteCell: UITableViewCell {
    
    
    
    var note: Note? {
        didSet {
            topicLabel.text = note?.topic
            
            if let imageData = note?.imageData {
                noteImageView.image = UIImage(data: imageData)
            }
            
            detailLabel.text = note?.noteDescription
            
            
            
            if let seconds = note?.timestamp {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
        }
    }
    
    
    let noteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.flatBlue.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    let topicLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.flatPowderBlue
        
        addSubview(noteImageView)
        noteImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        noteImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        noteImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        noteImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        addSubview(topicLabel)
        topicLabel.leftAnchor.constraint(equalTo: noteImageView.rightAnchor, constant: 8).isActive = true
        topicLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        topicLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        topicLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3).isActive = true
        
        addSubview(detailLabel)
        detailLabel.topAnchor.constraint(equalTo: topicLabel.bottomAnchor).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: noteImageView.rightAnchor, constant: 8).isActive = true
        detailLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
