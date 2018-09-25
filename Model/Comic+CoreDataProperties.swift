//
//  Comic+CoreDataProperties.swift
//  MarvelApp
//
//  Created by Intermat on 24/09/2018.
//  Copyright © 2018 Yuji Hato. All rights reserved.
//
//

import Foundation
import CoreData


extension Comic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comic> {
        return NSFetchRequest<Comic>(entityName: "Comic")
    }

    @NSManaged public var cover: String?
    @NSManaged public var creaters: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var favorite: Bool
    @NSManaged public var idComic: Int64
    @NSManaged public var info: String?
    @NSManaged public var persons: String?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var tumb: String?

}
