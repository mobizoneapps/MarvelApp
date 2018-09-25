
import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var resultsIcons: NSArray? = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = "Favoritos"
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "sort")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addTapped))
        navigationItem.rightBarButtonItem = rightButton
        
        
        self.tableView.registerCellNib(DataTableViewCell.self)
        
        UITabBar.appearance().tintColor = UIColor.white
        
        let colorTint =  UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
        if #available(iOS 10.0, *) {
            UITabBar.appearance().unselectedItemTintColor = colorTint
        } else {
            
            
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: colorTint], for: UIControlState.normal)
            
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: colorTint], for:UIControlState.selected)
            UITabBar.appearance().tintColor = colorTint
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        
        self.resultsIcons = ComicDAO.getFavorities(context!, orderByDate: false)
        self.tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func addTapped() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let alert = UIAlertController(title: "", message: "Ordenar Itens por", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let action1 = UIAlertAction(title: "Título", style: .default) { (action:UIAlertAction) in
            
            self.resultsIcons = ComicDAO.getFavorities(context!, orderByDate: false)
            self.tableView.reloadData()
            
        }
        
        alert.addAction(action1)
        
        let action2 = UIAlertAction(title: "Data", style: .default) { (action:UIAlertAction) in
            
            self.resultsIcons = ComicDAO.getFavorities(context!, orderByDate: true)
            self.tableView.reloadData()
            
        }
        
        alert.addAction(action2)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
}


extension FavoriteViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DataTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "SubContentsViewController") as! SubContentsViewController
        
        let comic = self.resultsIcons![indexPath.row] as! Comic
        
        subContentsVC.idComic = comic.idComic
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension FavoriteViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print((self.resultsIcons?.count)!)
        return (self.resultsIcons?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.identifier) as! DataTableViewCell
        
        let comic = self.resultsIcons![indexPath.row] as! Comic
        
        let data = DataTableViewCellData(imageUrl: comic.tumb!, text: comic.title!, date: comic.date!)
        cell.setData(data)
        return cell
    }
}
