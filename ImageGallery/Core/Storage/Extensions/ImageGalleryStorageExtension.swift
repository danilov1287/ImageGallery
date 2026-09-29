//
//  ImageGalleryStorageExtension.swift
//  ImageGallery
//
//  Created by Oleg on 26.09.2026.
//
import CoreData

extension ImageGalleryStorage {
    /// Сохранить картинку в избранное (если её ещё нет)
    func addToFavorites(_ image: OpenverseImage) throws {
        let context = viewContext

        let request = NSFetchRequest<FavoriteImage>(entityName: "FavoriteImage")
        request.predicate = NSPredicate(format: "id == %@", image.id)
        request.fetchLimit = 1
        let existing = try context.fetch(request)

        if existing.isEmpty {//создаём новую сущность
            _ = FavoriteImage.from(openverseImage: image, context: context)
            // Сохраняем изменения
            try context.save()
        }
    }

    /// Удалить из избранного
    func removeFromFavorites(_ image: OpenverseImage) throws {
        let context = viewContext
        
        // Создаём запрос для поиска существующего объекта
        let fetchRequest = NSFetchRequest<FavoriteImage>(entityName: "FavoriteImage")
        fetchRequest.predicate = NSPredicate(format: "id == %@", image.id) // Ищем по ID
        let results = try context.fetch(fetchRequest)
        
        // Если объект найден — удаляем его
        if let favoriteImage = results.first {
            context.delete(favoriteImage)
        }
        
        // Сохраняем изменения в базе
        try context.save()
    }

    // Проверить, есть ли картинка в избранном (для кнопки "Звезда")
    func isFavorite(id: String) -> Bool {
        do {
            let context = viewContext
            let request = NSFetchRequest<FavoriteImage>(entityName: "FavoriteImage")
            request.predicate = NSPredicate(format: "id == %@", id)
            request.fetchLimit = 1
            let favoriteImages = try context.fetch(request)
            return favoriteImages.count > 0
        } catch {
            print("Ошибка проверки избранного: \(error)")
            return false
        }
    }
    
    func fetchAllFavorites() throws -> [OpenverseImage] {
        let context = viewContext
        let fetchRequest = NSFetchRequest<FavoriteImage>(entityName: "FavoriteImage")
        
        let entities = try context.fetch(fetchRequest)
        return entities.map { $0.toOpenverseImage() }
    }
}
