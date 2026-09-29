//
//  FavoriteImage.swift
//  ImageGallery
//
//  Created by Oleg on 24.09.2026.
//

import CoreData
@objc(ConfigApp)
final class ConfigApp: NSManagedObject {
    @NSManaged var appKey: String
    @NSManaged var appValue: String
}
