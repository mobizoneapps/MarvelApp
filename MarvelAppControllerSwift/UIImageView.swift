

import UIKit
import Alamofire
import AlamofireImage


extension UIImageView {
    
    func getImage(_ urlString: String) {
        
        if self.image != nil {
            self.alpha = 1
            return
        }
        self.alpha = 0
        
        if urlString == ""{
            return
        }
        
        let urlStr = urlString.replacingOccurrences(of: "http", with: "https")
        
        let url = URL(string: urlStr)!
  
        
        Alamofire.request(url).responseImage { response in
            
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    self.image = (response.result.value != nil) ? response.result.value : #imageLiteral(resourceName: "placeholder")
                    
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.alpha = 1
                    }, completion: { (finished: Bool) -> Void in
                    })
                })
              
                
            
        }
        
        
    }
    
    
    
    func clipParallaxEffect(_ baseImage: UIImage?, screenSize: CGSize, displayHeight: CGFloat) {
        if let baseImage = baseImage {
            if displayHeight < 0 {
                return
            }
            let aspect: CGFloat = screenSize.width / screenSize.height
            let imageSize = baseImage.size
            let imageScale: CGFloat = imageSize.height / screenSize.height
            
            let cropWidth: CGFloat = floor(aspect < 1.0 ? imageSize.width * aspect : imageSize.width)
            let cropHeight: CGFloat = floor(displayHeight * imageScale)
            
            let left: CGFloat = (imageSize.width - cropWidth) / 2
            let top: CGFloat = (imageSize.height - cropHeight) / 2
            
            let trimRect : CGRect = CGRect(x: left, y: top, width: cropWidth, height: cropHeight)
            self.image = baseImage.trim(trimRect: trimRect)
            self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: displayHeight)
        }
    }
    
    
}


