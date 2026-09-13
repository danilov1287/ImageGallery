//
//  Secrets.swift
//  ImageGallery
//
//  Created by Oleg on 13.09.2026.
//

import Foundation


struct Secrets {
    static let shared = Secrets()

    let clientId: String
    let clientSecret: String

    private init() {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: url) as? [String: Any],
              let clientId = dict["clientId"] as? String,
              let clientSecret = dict["clientSecret"] as? String
        else {
            fatalError("Secrets.plist not found or invalid. Use Secrets.plist.sample to create your own.")
        }
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
}
