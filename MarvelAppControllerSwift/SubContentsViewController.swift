
import UIKit
import CoreData

class SubContentsViewController : UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var charactersLabel: UILabel!
    @IBOutlet weak var creatersLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    
    
    var idComic: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let comic = ComicDAO.findComic(context!, id: idComic)
        
        titleLabel.text = comic?.title
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = tempLocale
        
        if let datePublic = comic?.date {
            dateLabel.text = dateFormatter.string(from: datePublic as! Date)
        } else {
            dateLabel.text = ""
        }
        
        priceLabel.text = String(format:"%.2f", (comic?.price)!)
        descriptionLabel.text = comic?.info
        charactersLabel.text = comic?.persons
        creatersLabel.text = comic?.creaters
        
        
        let cover = comic?.cover == nil ? comic?.tumb : comic?.cover
        
        imageView.getImage(cover!)
        
        setFavButton((comic?.favorite)!)
        
    }
    
    @IBAction func favAction(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        ComicDAO.setFavorite(context!, id: idComic, fav: favButton.tag == 0)
        
        setFavButton(favButton.tag == 0)
        
    }
    
    func setFavButton(_ isFav: Bool) {
        
        if isFav {
            favButton.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
            favButton.tag = 1
        } else {
            favButton.setImage(#imageLiteral(resourceName: "unfav"), for: .normal)
            favButton.tag = 0
        }
        
    }
    
   
}
