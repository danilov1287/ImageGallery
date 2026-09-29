//
//  ImageTitleCell.swift
//  ImageGallery
//
//  Created by Oleg on 20.09.2026.
//
import Kingfisher
import UIKit


class ImageTitleCell: UITableViewCell {
    
    static let identifier = "ImageTitleCell"
    
    private let thumbnailView = UIImageView()
    private let errorImageView = UIImageView()
    private let titleLabel = UILabel()
    private var items: [UIView]
    var onImageLoad: ((Bool) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.items = [thumbnailView, errorImageView, titleLabel]
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Картинка: квадратик, aspect fill
        thumbnailView.contentMode = .scaleAspectFill
        thumbnailView.clipsToBounds = true
        thumbnailView.layer.cornerRadius = 8
        
        errorImageView.image = UIImage(systemName: "photo")?.withTintColor(
            .systemGray,
            renderingMode: .alwaysOriginal
        )
        errorImageView.contentMode = .scaleAspectFit
        errorImageView.layer.cornerRadius = 8
        errorImageView.isHidden = true
        
        // Заголовок: слева от картинки, текст переносится
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.adjustsFontSizeToFitWidth = false
        
        items.forEach{
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        items.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let thumbnailBottom = thumbnailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        thumbnailBottom.priority = .init(999)
        NSLayoutConstraint.activate([
            // Картинка слева, отступ от краёв и от текста
            thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            thumbnailBottom,
            thumbnailView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailView.heightAnchor.constraint(equalToConstant: 80),
            
            // показать в случае ошибки
            errorImageView.leadingAnchor.constraint(equalTo: thumbnailView.leadingAnchor),
            errorImageView.topAnchor.constraint(equalTo: thumbnailView.topAnchor),
            errorImageView.widthAnchor.constraint(equalTo: thumbnailView.widthAnchor),
            errorImageView.heightAnchor.constraint(equalTo: thumbnailView.heightAnchor),
            
            // Заголовок справа от картинки
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(
        title: String, url: URL?, loadState: GalleryModels.ImageLoadState?,
        onImageLoad: ((Bool) -> Void)?
    ) {
        // 1. Сначала сбрасываем состояние ячейки при переиспользовании
        titleLabel.text = title
        thumbnailView.kf.cancelDownloadTask()          // отменяем старую загрузку, если есть
        thumbnailView.image = nil                      // убираем старую картинку
        errorImageView.isHidden = true
        
        // 2. Если URL нет — просто выходим, ничего не грузим
        guard let url else {
            errorImageView.isHidden = false
            return
        }
        
        // Если уже загружено — не запускаем Kingfisher заново
        if loadState == .loaded {
            let processor = RoundCornerImageProcessor(radius: .point(8))
            thumbnailView.kf.setImage(with: url, options: [.processor(processor)])
            return
        }
        
        // Если ранее было .failed — показываем иконку ошибки
        if loadState == .failed {
            errorImageView.isHidden = false
            thumbnailView.image = UIImage.color(.systemGray4, size: CGSize(width: 80, height: 80))
            return
        }
        
        // 3. Настраиваем опции для Kingfisher:
        // - processor: скругление углов (как у тебя было в setupViews)
        // - transition: плавное появление картинки
        // - placeholder: серый прямоугольник вместо пустоты, пока грузится
        let processor = RoundCornerImageProcessor(radius: .point(8))
        let transition = ImageTransition.fade(0.25)
        let placeholder = UIImage.color(.systemGray4, size: CGSize(width: 80, height: 80))
        
        thumbnailView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .processor(processor),
                .transition(transition)
            ],
            progressBlock: nil,
        ){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                onImageLoad?(true)
                break
            case .failure:
                onImageLoad?(false)
                self.errorImageView.isHidden = false
            }
        }
    }
}


