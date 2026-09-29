//
//  GalleryInteractor.swift
//  ImageGallery
//
//  Created by Oleg on 24.09.2026.
//


import Foundation

final class FavoritesInteractor {
    private var presenter: FavoritesPresenter
    
    let serviceCoreData: ImageGalleryStorageListProtocol
    init(
        presenter: FavoritesPresenter
    ) {
        self.presenter = presenter
        self.serviceCoreData = ImageGalleryStorage.shared
    }
    func loadImageList() {
        do{
            let favoriteImages = try serviceCoreData.fetchAllFavorites()
            self.presenter.presentFavoritesImages(images: favoriteImages)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
}
