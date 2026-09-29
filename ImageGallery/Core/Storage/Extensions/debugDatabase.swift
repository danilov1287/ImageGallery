//
//  Extension+debugDatabase.swift
//  ImageGallery
//
//  Created by Oleg on 25.09.2026.
//

import CoreData

extension NSPersistentContainer {
    /// Выводит в консоль все сущности модели и проверяет наличие конкретной
    func debugDatabase(checkEntityName: String? = nil) {
        print("--- НАЧАЛО ДИАГНОСТИКИ МОДЕЛИ ---")
        
        let entities = managedObjectModel.entitiesByName
        
        if !entities.isEmpty {
            print("Сущности в модели (всего \(entities.count)):")
            for (name, entity) in entities {
                // Дополнительно покажем, какой класс привязан (если задан)
                let className = entity.managedObjectClassName ?? "(нет класса)"
                print("  - \(name) → \(className)")
            }
        } else {
            print("Модель пуста!")
        }
        
        // Проверка конкретной сущности, если имя передано
        if let entityName = checkEntityName {
            if entities[entityName] != nil {
                print("✅ Сущность '\(entityName)' НАЙДЕНА в модели.")
            } else {
                print("❌ Сущность '\(entityName)' НЕ найдена в модели!")
                print("Проверь имя в .xcdatamodeld!")
            }
        }
        
        print("--- КОНЕЦ ДИАГНОСТИКИ ---")
    }
}
