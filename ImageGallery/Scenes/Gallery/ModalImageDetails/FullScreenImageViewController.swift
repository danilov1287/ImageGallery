//
//  FullScreenImageViewController.swift
//  ImageGallery
//
//  Created by Oleg on 22.09.2026.
//
import UIKit
import Kingfisher

final class FullScreenImageViewController: UIViewController {
    let imageItem: OpenverseImage
    var isFavorite: Bool = false
    var interactor: GalleryImageDetailsInteractorProtocol?

    private lazy var closeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("✕", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(close), for: .touchUpInside)
        return b
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()

        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func configureFavoriteButton() {
        favoriteButton.configuration = {
            var config = UIButton.Configuration.plain()
//            config.title = "Избранное"
            config.image = UIImage(systemName: isFavorite ? "star.fill" : "star")
            config.imagePlacement = .trailing          // ⭐ Иконка СПРАВА от текста
            config.imagePadding = 8                    // Расстояние между текстом и звездой
            config.baseForegroundColor = .label        // Цвет текста (серый, как у неактивной вкладки)
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            return config
        }()
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .medium)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        
        v.numberOfLines = 0
        v.textAlignment = .left
        v.font = .systemFont(ofSize: 16)
        // Критично: задаём ширину для расчёта строк
        let maxWidth = view.bounds.width - 32 // 16 слева + 16 справа
        v.preferredMaxLayoutWidth = maxWidth
        // Чтобы лейбл сам определял высоту
        v.setContentCompressionResistancePriority(.required, for: .vertical)
        v.setContentHuggingPriority(.required, for: .vertical)
        
        return v
    }()
    
    private func setLoading() {
        scrollView.isHidden = true
        closeButton.isHidden = true
        activityIndicator.startAnimating()
    }
    private func unsetLoading(){
        scrollView.isHidden = false
        closeButton.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    init(imageItem: OpenverseImage) {
        self.imageItem = imageItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureFavoriteButton()
        setupUI()
        configureContent()
        self.interactor?.isModalLoaded() // уберем загрузку в модальном окне
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func setupUI() {
        [closeButton, scrollView, activityIndicator].forEach {
            view.addSubview($0)
        }
        [imageView, descriptionLabel, favoriteButton].forEach {
            scrollView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // --- closeButton (крестик вверху экрана) ---
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),

            // --- scrollView (занимает всё пространство под кнопкой) ---
            scrollView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // --- imageView (ПЕРВЫЙ ЭЛЕМЕНТ: большая картинка по центру) ---
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.75),

            // --- favoriteButton (ВТОРОЙ ЭЛЕМЕНТ: по центру, маленький отступ) ---
            favoriteButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor), // центрируем горизонтально
            favoriteButton.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: 12                     // уменьшенный отступ от картинки
            ),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),  // чуть меньше
            favoriteButton.heightAnchor.constraint(equalToConstant: 44), // чуть меньше

            // --- descriptionLabel (ТРЕТИЙ ЭЛЕМЕНТ: слева, маленький отступ от кнопки) ---
            descriptionLabel.topAnchor.constraint(
                equalTo: favoriteButton.bottomAnchor,
                constant: 8                      // уменьшенный отступ между кнопкой и текстом
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor,
                constant: 16
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor,
                constant: -16
            ),

            // --- activityIndicator (по центру экрана, поверх всего) ---
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])


    }
    
    private func configureContent() {
        setLoading()
        if let thumbnailString = imageItem.thumbnail,
           let url = URL(string: thumbnailString) {
            self.unsetLoading()
            imageView.kf.setImage(with: url)
        } else {
            self.unsetLoading()
            imageView.image = UIImage(systemName: "photo")
        }
        descriptionLabel.text = imageItem.title
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
    @objc private func toggleFavorite(){
        self.isFavorite.toggle()
        configureFavoriteButton()
        // здесь будет запись
        guard let interactor = self.interactor else { return }
        isFavorite ? interactor.setFavorite(for: imageItem) : interactor.unsetFavorite(for: imageItem)
    }
}
