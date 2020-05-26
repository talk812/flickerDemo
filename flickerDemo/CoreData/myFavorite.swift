//
//  myFavorite.swift
//  flickerDemo
//
//  Created by william on 2020/5/26.
//  Copyright © 2020 william. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let ENTITY_NAME = "PhotoDatas"

class myFavorite {
    
    static public var sharedInstance: myFavorite = myFavorite()
    lazy var context: NSManagedObjectContext = {
        let context = ((UIApplication.shared.delegate) as! AppDelegate).context
        return context
    }()
    
    // 更新数据
    private func saveContext() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func insertData(photo: Photo) {
        let photodata = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: context) as! PhotoDatas
        photodata.imageUrl = photo.imageUrl
        photodata.title = photo.title
        photodata.id = photo.id
        saveContext()
    }
    
    func removeDataByID(id: String) {
        let fetchRequest: NSFetchRequest = PhotoDatas.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let result = try context.fetch(fetchRequest)
            for photo in result {
                context.delete(photo)
            }
        } catch {
            fatalError();
        }
        saveContext()
    }
    
    func getAllData() -> [PhotoDatas] {
        let fetchRequest: NSFetchRequest = PhotoDatas.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            fatalError()
        }
    }
}
