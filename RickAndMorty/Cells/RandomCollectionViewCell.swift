//
//  RandomCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Тимур Ахметов on 24.04.2022.
//

import UIKit

class RandomCharacterCollectionViewCell: UICollectionViewCell {
    
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 0.5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        characterImageView.layer.cornerRadius = characterImageView.frame.width / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .none
        
        addSubview(characterImageView)
    }
    
    func cellConfigure(model: Result) {
        let url: URL = URL(string: "https://rickandmortyapi.com/api/character/avatar/\(model.id).jpeg")!
        
        NetworkImageFetch.shared.requestImage(url: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self.characterImageView.image = image
            case .failure(_):
                print("DetailsVC no image")
            }
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            characterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            characterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
