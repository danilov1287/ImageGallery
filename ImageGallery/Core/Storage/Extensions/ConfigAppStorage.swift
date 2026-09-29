//
//  ConfigAppStorageProtocol.swift
//  ImageGallery
//
//  Created by Oleg on 27.09.2026.
//
import CoreData

protocol ConfigAppStorageProtocol {
    func fetchAllConfigApp() throws -> [String: String]
    func saveConfigApp(appConfig: [String: String]) throws
}

extension ImageGalleryStorage: ConfigAppStorageProtocol{
    func fetchAllConfigApp() throws -> [String : String] {
        let context = viewContext
        let fetchRequest = NSFetchRequest<ConfigApp>(entityName: "ConfigApp")
        let entities = try context.fetch(fetchRequest)
        var appConfig: [String: String] = [:]
        entities.forEach {
            appConfig[$0.appKey] = $0.appValue
        }
        return appConfig
    }
    
    func saveConfigApp(appConfig: [String : String]) throws {
        let context = viewContext
        
        for (key, value) in appConfig {
            let request = NSFetchRequest<ConfigApp>(entityName: "ConfigApp")
            request.predicate = NSPredicate(format: "appKey == %@", key)
            request.fetchLimit = 1
            let existing = try context.fetch(request)
            if(existing.isEmpty){
                let configApp = ConfigApp.init(context: context)
                configApp.appKey = key
                configApp.appValue = value
            } else {
                existing.first?.appValue = value
            }
            try context.save()
        }
    }
}
