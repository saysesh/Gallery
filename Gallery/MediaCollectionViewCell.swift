//
//  MediaCollectionViewCell.swift
//  Gallery
//
//  Created by Saida Yessirkepova on 20.02.2023.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    
    private lazy  var mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .label
        label.text = "Name"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: ImageModel, _ mediaType: MediType) {
        switch mediaType {
        case .image:
            guard  let url = URL(string: model.previewURL) else { return }
            mediaImageView.kf.setImage(with: url)
            DispatchQueue.main.async {
                self.mediaImageView.kf.setImage(with: url)
                self.mediaImageView.contentMode = .scaleAspectFill

            }
        case .video:
            DispatchQueue.main.async {
                self.mediaImageView.image = UIImage(systemName: "play.circle.fill")
                self.mediaImageView.contentMode = .scaleAspectFit

            }

        }
    }
}

//MARK: - Setup views and constraints methods

private extension MediaCollectionViewCell {
    func setupViews(){
        contentView.addSubview(mediaImageView)
        contentView.addSubview(nameLabel)
    }
    func setupConstraints() {
        mediaImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(mediaImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
