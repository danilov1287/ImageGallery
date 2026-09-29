//
//  MainController.swift
//  Viper_Ricky_Example
//
//  Created by Nikolai Baklanov on 13.08.2026.
//

import Foundation

protocol GalleryViewControllerProtocol: AnyObject {
    func display(with viewModel: GalleryModels.ViewModel.State)
}
