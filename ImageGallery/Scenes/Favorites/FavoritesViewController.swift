//
//  FavoritesViewController.swift
//  ImageGallery
//
//  Created by Oleg on 23.09.2026.
//
import UIKit

class FavoritesViewController: UIViewController {
    var interactor: FavoritesInteractor?
    var images: [OpenverseImage] = []
    
    func display(images: [OpenverseImage]) {
        activityIndicator.stopAnimating()
        self.images = images
        tableView.reloadData()
        if( images.isEmpty ){// в избранном ничего нет - перезагрузить
            firstButton.isHidden = false
            tableView.isHidden = true
            return
        }
        tableView.isHidden = false
    }
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let tableView = UITableView()
    private let firstButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        loadFavoriteImageList()
    }
    
    private func setupUI() {
        firstButton.setTitle("В избранном ничего нет. Обновить?", for: .normal)
        firstButton.addTarget(self, action: #selector(loadFavoriteImageList), for: .touchUpInside)
        [activityIndicator, tableView, firstButton].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        activityIndicator.startAnimating()
        NSLayoutConstraint.activate([
            firstButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        // TableView
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.register(ImageTitleCell.self, forCellReuseIdentifier: ImageTitleCell.identifier)
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 104
    }
    @objc func loadFavoriteImageList() {
        Task { [weak self] in
            guard let self else { return }
            firstButton.isHidden = true
            activityIndicator.startAnimating()
            self.interactor?.loadImageList()
        }
    }
    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImageTitleCell.identifier,
            for: indexPath
        ) as? ImageTitleCell else {
            fatalError("Не удалось получить ячейку ImageTitleCell")
        }
        
        let item = images[indexPath.row]
        
        let thumbnailURL: URL? = getImageUrl(from: item.thumbnail)
        let title = item.title ?? "";
        cell.configure(title: title, url: thumbnailURL, loadState: nil, onImageLoad: nil)
        return cell
    }
    
    private func getImageUrl(from urlString: String?) -> URL? {
        guard let urlString,
              let url: URL = URL(string: urlString) else { return nil }
        return url
    }
}
