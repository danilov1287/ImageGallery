//
//  ViewController.swift
//  ImageGallery
//
//  Created by Oleg on 13.09.2026.
//

import UIKit

class GalleryViewController: UIViewController, GalleryViewControllerProtocol {
    var interactor: GalleryInteractorProtocol?
    
    private let firstButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let tableView = UITableView()
    
    private var images: [GalleryModels.ImageViewModel] = []
    private var state: GalleryModels.ViewModel.State = .loadImageList //.tryAgain
    
    func display(with viewModelState: GalleryModels.ViewModel.State) {
        state = viewModelState
        switch state {
        case .loading:
            isLoading(isLoading: true)
        case .loadImageList:
            isLoading(isLoading: true)
            loadImageList()
        case .populated(let images):
            // Показать список, скрыть индикатор
            self.images = images
            activityIndicator.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()        // обновить таблицу
        case .showTable:
            activityIndicator.stopAnimating()
            tableView.isHidden = false
        case .tryAgain:
            firstButton.isHidden = false
            tableView.isHidden = true
            activityIndicator.stopAnimating()
        case .error(let string):
            showError(string)
            display(with: .tryAgain)
            
        }
    }
    
    func isLoading(isLoading: Bool) {
        isLoading ? enterLoadingState() : exitLoadingState();
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        display(with: state)
    }
    
    func setupUI() {
        // Кнопки
        firstButton.setTitle("Произошла ошибка. Повторить?", for: .normal)
        [firstButton, activityIndicator, tableView].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
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
        firstButton.addTarget(self, action: #selector(loadImageList), for: .touchUpInside)
        // TableView
        tableView.isHidden = true
        tableView.dataSource = self
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ImageTitleCell.self, forCellReuseIdentifier: ImageTitleCell.identifier)
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 104
    }
    
    // Состояние загрузки: скрываем кнопку, показываем индикатор
    private func enterLoadingState() {
        firstButton.isHidden = true
        tableView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    // Возвращаем исходное состояние
    private func exitLoadingState() {
        tableView.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    @objc func loadImageList() {
        Task { [weak self] in
            guard let self else { return }
            let request = GalleryModels.Request(pageSize: 15)
            await self.interactor?.loadImageList(request)
        }
    }
}

// MARK: - UITableViewDelegate
extension GalleryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Task { [weak self] in
            guard let self else { return }
            let item = images[indexPath.row]
            let request = FullScreenImageModels.Request(item: item)
            await self.interactor?.loadImageDetails(request)
        }
    }
}

// MARK: - UITableViewDataSource
extension GalleryViewController: UITableViewDataSource {
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
        cell.configure(
            title: item.title,
            url: item.thumbnailURL,
            loadState: item.loadState,
            onImageLoad: { [weak self] isLoaded in
                guard let self = self else { return }
                
                let newState: GalleryModels.ImageLoadState = isLoaded ? .loaded : .failed
                
                if self.images[indexPath.row].loadState != newState {
                    self.images[indexPath.row].loadState = newState
                }
            })
        return cell
    }
}

