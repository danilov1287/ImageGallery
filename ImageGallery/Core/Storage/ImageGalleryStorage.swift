//
//  ImageGalleryStorage.swift
//  ImageGallery
//
//  Created by Oleg on 13.09.2026.
//  NSPersistentContainer

import Foundation
import CoreData

final class ImageGalleryStorage: ImageGalleryStorageProtocol & ImageGalleryStorageListProtocol {
    static let shared = ImageGalleryStorage()
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init(modelName: String = "ImageGallery") {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            guard error == nil else {
                print("[CoreData] Load failed: \(error!.localizedDescription)")
                // В продакшене лучше не fatalError, а логировать и/или пробрасывать ошибку
                return
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
//        container.debugDatabase(checkEntityName: "FavoriteImage") 
        self.persistentContainer = container
    }
}
