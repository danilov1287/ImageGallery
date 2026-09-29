//
//  FavoritesPresenter.swift
//  ImageGallery
//
//  Created by Oleg on 24.09.2026.
//


final class FavoritesPresenter {
    private weak var view: FavoritesViewController?

    init(view: FavoritesViewController) {
        self.view = view
    }
    func presentFavoritesImages(images: [OpenverseImage]) {
        view?.display(images: images)
    }
    
    
}
