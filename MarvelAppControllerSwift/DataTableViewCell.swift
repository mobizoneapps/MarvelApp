
import UIKit



struct DataTableViewCellData {
    
    var imageUrl: String
    var text: String
    var date: NSDate!
    
    init(imageUrl: String, text: String, date: NSDate!) {
        self.imageUrl = imageUrl
        self.text = text
        self.date = date
    }
}

class DataTableViewCell : BaseTableViewCell {
    
    @IBOutlet weak var dataImage: UIImageView!
    @IBOutlet weak var dataText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    
    
    override func awakeFromNib() {
        self.dataText?.font = UIFont.italicSystemFont(ofSize: 16)
        self.dataText?.textColor = UIColor(hex: "9E9E9E")
        self.dateText?.textColor = UIColor(hex: "9E9E9E")
    }
    
    override class func height() -> CGFloat {
        return 80
    }
    
    override func setData(_ data: Any?) {
        
        if let data = data as? DataTableViewCellData {
            
            self.dataImage.getImage(data.imageUrl)
            self.dataText.text = data.text
            
            let dateFormatter = DateFormatter()
            let tempLocale = dateFormatter.locale
            
            
            if (data.date != nil) {
                
                dateFormatter.dateFormat = "dd/MM/yyyy"
                dateFormatter.locale = tempLocale
                let dateString = dateFormatter.string(from: data.date as Date)
                self.dateText.text = "Publicação: \(dateString)"
                
            } else {
                
                self.dateText.text = ""
                
            }
        }
    }
}
