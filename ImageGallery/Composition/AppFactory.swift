//
//  AppFactory.swift
//  ImageGallery
//
//  Created by Oleg on 13.09.2026.
//

import Foundation
import UIKit

final class AppFactory {
    private let service: ServiceFactory

    init(service: ServiceFactory) {
        self.service = service
    }
    @MainActor
    func makeMainViewController() -> UIViewController {
        let mainNav = UINavigationController(rootViewController: getGalleryViewController())
        mainNav.tabBarItem = UITabBarItem(
            title: "Основное",
            image: UIImage(systemName: "photo"),
            tag: 0
        )

        // --- Вкладка 2: Избранное ---
        let favNav = UINavigationController(rootViewController: getFavoritesViewController())
        favNav.tabBarItem = UITabBarItem(
            title: "Избранное",
            image: UIImage(systemName: "star"),
            tag: 1
        )

        // --- Вкладка 3: Настройки (пример) ---
        let settingsNav = UINavigationController(rootViewController: getSettingsViewController())
        settingsNav.tabBarItem = UITabBarItem(
            title: "Настройки",
            image: UIImage(systemName: "gear"),
            tag: 2
        )
        
        // --- Сборка TabBar ---
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mainNav, favNav, settingsNav]

        return tabBarController
    }
    @MainActor
    private func getGalleryViewController() -> GalleryViewController {
        let galleryVC = GalleryViewController()
        let galleryPresenter = GalleryPresenter(view: galleryVC)
        var imageService: ImageService? = nil
        do{
            imageService = try service.makeImageService()
        } catch {}
        let galleryInteractor = GalleryInteractor(
            presenter: galleryPresenter,
            service: imageService,
            serviceCoreData: service.makeCoreDataService()
        )
        let galleryRouter = GalleryRouter(factory: self, view: galleryVC)

        galleryVC.interactor = galleryInteractor
        galleryPresenter.router = galleryRouter
        return galleryVC
    }
    @MainActor
    private func getFavoritesViewController() -> FavoritesViewController {
        let favoritesVC = FavoritesViewController()
        let favoritesPresenter = FavoritesPresenter(view: favoritesVC)
        let favoritesInteractor = FavoritesInteractor(presenter: favoritesPresenter)
        favoritesVC.interactor = favoritesInteractor
        return favoritesVC
    }
    
    private func getSettingsViewController() -> SettingsViewController {
        let settingsVC = SettingsViewController()
        return settingsVC
    }
}
