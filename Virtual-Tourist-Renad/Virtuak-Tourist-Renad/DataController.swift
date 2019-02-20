//
//  DataController.swift
//  Virtuak-Tourist-Renad
//
//  Created by renad saleh on 15/02/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController{
    let persistantContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext{
        return persistantContainer.viewContext
    }
    
    init(modelName:String) {
        persistantContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil){
        persistantContainer.loadPersistentStores {storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
