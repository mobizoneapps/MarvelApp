

import UIKit
import CoreData

class ComicDAO: NSObject {
    
    
    class func saveComic(_ context: NSManagedObjectContext, jsonData: NSArray){
        
        let entity = NSEntityDescription.entity(forEntityName: "Comic", in: context)!
        
        for item in jsonData {
            
            let dic = item as! NSDictionary
            
            let idComic = dic["id"] as! Int64
            
            var obj = findComic(context, id: idComic)
            
            if !(obj != nil) {
                obj = NSManagedObject(entity: entity, insertInto: context) as! Comic
            }
            
            obj?.idComic = idComic
            obj?.title = dic["title"] as? String
            
            
            let thumbnail = dic["thumbnail"] as! NSDictionary
            let imageTumb = "\(thumbnail["path"] as! String)/standard_medium.\(thumbnail["extension"] as! String)"
            
            obj?.tumb = imageTumb
            
            let covers = dic["images"] as! NSArray
            
            if (covers.count > 0) {
                let coverObj = covers.firstObject as! NSDictionary
                
                let cover = "\(coverObj["path"] as! String)/standard_xlarge.\(coverObj["extension"] as! String)"
                
                obj?.cover = cover
                
            }
            
            let creatorsDic = dic["creators"] as! NSDictionary
            let creatorsItem = creatorsDic["items"] as! NSArray
            
            var creators: String = ""
            
            for  itemCreator in creatorsItem {
                
                let item = itemCreator as! NSDictionary
                creators =   "\(creators), \(item["name"] as! String)"
                
            }
            
            
            let personDic = dic["characters"] as! NSDictionary
            let personItem = personDic["items"] as! NSArray
            
            var persons: String = ""
            
            for  itemPerson in personItem {
                
                let item = itemPerson as! NSDictionary
                persons =   "\(persons), \(item["name"] as! String)"
                
            }
            
            let prices = dic["prices"] as! NSArray
            let price = prices.firstObject as! NSDictionary
            
            obj?.price = price["price"] as! Double
            
            if creators.length > 0 {
                obj?.creaters = creators.substring(2)
            }
            
            if persons.length > 0 {
                obj?.persons = persons.substring(2)
            }
            
            obj?.info = dic["description"] as? String
            
            let dates = dic["dates"] as! NSArray
            let datePubliDic = dates.firstObject as! NSDictionary
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            
            if let datePublic = datePubliDic["date"] {
                
                do {
                    
                    if dateFormatter.date(from: datePublic as! String) != nil {
                        
                        let date =  dateFormatter.date(from: datePublic as! String)!
                        obj?.date = date as NSDate
                        
                    } else {
                        // invalid format
                        print ("sss" )
                    }
                    
                  
                    
                } catch {
                    
                    print ("Date Error")
                }
                
           
            }
            
        
            
            do {
                
                try context.save()
                
            } catch {
                
                print("Failed saving")
            }
        }
        
    }
    
    
    class func setFavorite(_ context: NSManagedObjectContext, id: Int64, fav: Bool)  {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Comic")
        request.predicate = NSPredicate(format: "idComic = %d", id)
        request.returnsObjectsAsFaults = false
        
        
        do {
            
            let result = try context.fetch(request)
            
            let comic = result.first as? Comic
            comic?.favorite = fav
            
            try context.save()
            
        } catch {
            
            print("Failed saving")
        }
        
        
    }
    
    
    
    
    class func findComic(_ context: NSManagedObjectContext, id: Int64) -> Comic? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Comic")
        request.predicate = NSPredicate(format: "idComic = %d", id)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            return result.first as? Comic
            
        } catch {
            
            print("Failed")
            return nil
        }
    }
    
    
    class func getAll(_ context: NSManagedObjectContext, orderByDate: Bool) -> NSArray? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Comic")
        request.returnsObjectsAsFaults = false
        
        
        let sort = NSSortDescriptor(key: orderByDate ? "date": "title", ascending: true)
        
        request.sortDescriptors = [sort]
        
        do {
            let result = try context.fetch(request)
            
            return result as! NSArray
            
        } catch {
            
            print("Failed")
            return nil
        }
    }
    
    class func getFavorities(_ context: NSManagedObjectContext, orderByDate: Bool) -> NSArray? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Comic")
        request.predicate = NSPredicate(format: "favorite = true")
        
        let sort = NSSortDescriptor(key: orderByDate ? "date": "title", ascending: true)
        
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            return (result as! NSArray)
            
            
        } catch {
            
            print("Failed")
            return nil
        }
    }
    
    
}
