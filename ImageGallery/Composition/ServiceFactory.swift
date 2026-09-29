//
//  ServiceFactory.swift
//  ImageGallery
//
//  Created by Oleg on 13.09.2026.
//

import Foundation

final class ServiceFactory {
    
    func makeImageService() throws -> ImageService {
        let imageService = ImageService()
        let appConfigCoreData: ConfigAppStorageProtocol = ImageGalleryStorage.shared

        let appConfig: [String: String]
        do {
            appConfig = try appConfigCoreData.fetchAllConfigApp()
        } catch {
            throw APIError.missingCredentials
        }

        guard let clientId = appConfig["clientId"],
              let clientSecret = appConfig["clientSecret"] else {
            throw APIError.missingCredentials
        }

        imageService.clientId = clientId
        imageService.clientSecret = clientSecret

        return imageService
    }

    
    func makeCoreDataService() -> ImageGalleryStorageProtocol {
        return ImageGalleryStorage.shared
    }
}
