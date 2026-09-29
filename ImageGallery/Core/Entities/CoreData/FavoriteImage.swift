//
//  FavoriteImage.swift
//  ImageGallery
//
//  Created by Oleg on 24.09.2026.
//

import CoreData
@objc(FavoriteImage)
final class FavoriteImage: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var title: String?
    @NSManaged var url: String
    @NSManaged var thumbnail: String?

    @NSManaged var width: Int
    @NSManaged var height: Int
    @NSManaged var license: String?
    @NSManaged var creator: String?
}

extension FavoriteImage {
    /// Создаёт сущность Core Data из сетевого Struct
    static func from(openverseImage: OpenverseImage, context: NSManagedObjectContext) -> FavoriteImage {
        let entity = FavoriteImage(context: context)
        
        entity.id = openverseImage.id
        entity.title = openverseImage.title
        entity.url = openverseImage.url
        entity.thumbnail = openverseImage.thumbnail
        entity.width = Int(openverseImage.width ?? 0)
        entity.height = Int(openverseImage.height ?? 0)
        entity.license = openverseImage.license
        entity.creator = openverseImage.creator
        
        return entity
    }
    
    /// Превращает сущность Core Data обратно в Struct (для передачи в Presenter/View)
    func toOpenverseImage() -> OpenverseImage {
        return OpenverseImage(
            id: self.id,
            title: self.title ?? "",
            url: self.url,
            thumbnail: self.thumbnail,
            width: Int(self.width),
            height: Int(self.height),
            license: self.license,
            creator: self.creator
        )
    }
}
