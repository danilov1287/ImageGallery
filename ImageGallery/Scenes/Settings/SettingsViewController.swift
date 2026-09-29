//
//  FavoritesViewController.swift
//  ImageGallery
//
//  Created by Oleg on 23.09.2026.
//
import UIKit
import CoreData

enum SettingLoadState{
    case loading
    case loaded
}

class SettingsViewController: UIViewController {
    private var state: SettingLoadState = .loaded
    private let service: ConfigAppStorageGodObjectProtocol = ImageGalleryStorage.shared

    private lazy var apiConfig: [String: String] = [
        "clientId": "API_KEY",
        "clientSecret": "API_SECRET"
    ]
    
    private lazy var titleLabel1: UILabel = {
        let label = UILabel()
        label.text = "clientId"
        return label
    }()
    private lazy var valueField1:UITextField = {
        let text = UITextField()
        text.text = apiConfig["clientId"]
        return text
    }()

    private lazy var titleLabel2: UILabel = {
        let label = UILabel()
        label.text = "clientSecret"
        return label
    }()
    private lazy var valueField2:UITextField = {
        let text = UITextField()
        text.text = apiConfig["clientSecret"]
        return text
    }()
    
    private lazy var titleLabel3 = {
        let label = UILabel()
        label.text = "Автор приложения: Олег Данилов\n09.2026"
        label.numberOfLines = 0
        return label
    }()
    private let saveButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadConfig()
        configureViews()
        setupConstraints()

        displayState(self.state)
    }
    
    private func loadConfig(){
        displayState(.loading)

        do{
            let apiConfig = try service.getConfigApp()
            guard apiConfig.isEmpty else {
                return setApiConfig(apiConfig: apiConfig)
            }
        } catch {
            print("\(error.localizedDescription)")

        }
        let apiConfig: [String:String] = [
            "clientId": Secrets.shared.clientId,
            "clientSecret": Secrets.shared.clientSecret
        ]
        return setApiConfig(apiConfig: apiConfig)
    }
    private func setApiConfig(apiConfig: [String:String]){
        valueField1.text = apiConfig["clientId"]
        valueField2.text = apiConfig["clientSecret"]
        self.apiConfig = apiConfig
        displayState(.loaded)
    }

    private func displayState(_ newState: SettingLoadState?) {
        state = newState ?? state
        let elements: [UIView] = [
            titleLabel1, valueField1,
            titleLabel2, valueField2,
            titleLabel3,
            saveButton,
        ]
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            elements.forEach { $0.isHidden = true }
        case .loaded:
            activityIndicator.stopAnimating()
            elements.forEach { $0.isHidden = false }
        }
    }
    
    private func configureViews() {
        // Общие настройки лейблов
        [titleLabel1, titleLabel2, titleLabel3].forEach { label in
            label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            label.textColor = .darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Общие настройки полей ввода
        [valueField1, valueField2].forEach { field in
            field.borderStyle = .roundedRect
            field.font = UIFont.systemFont(ofSize: 16)
            field.translatesAutoresizingMaskIntoConstraints = false
            field.clearButtonMode = .whileEditing
        }
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        // Кнопка
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        saveButton.backgroundColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(onSave), for: .touchUpInside)
        
        // Добавляем на view
        [
            titleLabel1, valueField1,
            titleLabel2, valueField2,
            titleLabel3,
            saveButton, activityIndicator
        ].forEach {
            view.addSubview($0)
        }
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 16
        let fieldHeight: CGFloat = 44
        let spacing: CGFloat = 8
        
        NSLayoutConstraint.activate([
            // --- Первая пара ---
            titleLabel1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            titleLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            valueField1.topAnchor.constraint(equalTo: titleLabel1.bottomAnchor, constant: spacing),
            valueField1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            valueField1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            valueField1.heightAnchor.constraint(equalToConstant: fieldHeight),
            
            // --- Вторая пара ---
            titleLabel2.topAnchor.constraint(equalTo: valueField1.bottomAnchor, constant: 24),  // отступ между блоками
            titleLabel2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            valueField2.topAnchor.constraint(equalTo: titleLabel2.bottomAnchor, constant: spacing),
            valueField2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            valueField2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            valueField2.heightAnchor.constraint(equalToConstant: fieldHeight),
            
            // --- Третья пара ---
            titleLabel3.topAnchor.constraint(equalTo: valueField2.bottomAnchor, constant: 24),
            titleLabel3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            // --- Кнопка ---
            saveButton.topAnchor.constraint(equalTo: titleLabel3.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc private func onSave() {
        apiConfig["clientId"]    = valueField1.text ?? ""
        apiConfig["clientSecret"] = valueField2.text ?? ""
        do{
            try service.setConfigApp(appConfig: apiConfig)
        } catch{
            print("\(error.localizedDescription)")
        }
    }
}

protocol ConfigAppStorageGodObjectProtocol {
    func getConfigApp() throws -> [String: String]
    func setConfigApp(appConfig: [String: String]) throws
}

extension ImageGalleryStorage: ConfigAppStorageGodObjectProtocol {
    func getConfigApp() throws -> [String : String] {
        let context = viewContext
        let fetchRequest = NSFetchRequest<ConfigApp>(entityName: "ConfigApp")
        let entities = try context.fetch(fetchRequest)
        var appConfig: [String: String] = [:]
        entities.forEach {
            appConfig[$0.appKey] = $0.appValue
        }
        return appConfig
    }
    
    func setConfigApp(appConfig: [String : String]) throws {
        let context = viewContext
        
        for (key, value) in appConfig {
            let request = NSFetchRequest<ConfigApp>(entityName: "ConfigApp")
            request.predicate = NSPredicate(format: "appKey == %@", key)
            request.fetchLimit = 1
            let existing = try context.fetch(request)
            if(existing.isEmpty){
                let configApp = ConfigApp.init(context: context)
                configApp.appKey = key
                configApp.appValue = value
            } else {
                existing.first?.appValue = value
            }
            try context.save()
        }
    }
}
