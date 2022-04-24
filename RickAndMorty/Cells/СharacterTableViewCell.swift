//
//  СharacterTableViewCell.swift
//  RickAndMorty
//
//  Created by Тимур Ахметов on 24.04.2022.
//

import UIKit

class СharacterTableViewCell: UITableViewCell {
    
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameCharacterLabel = UILabel(text: "",
                                     font: .getBoldLabel22(),
                                     color: .specialBlueLabel)
    
    let speciesLabel = UILabel(text: "",
                               font: .getRegularLabel18(),
                               color: .specialGreen)
    
    let genderLabel = UILabel(text: "",
                              font: .getRegularLabel18(),
                              color: .specialGreen)
    
    private var characterStackView = UIStackView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        characterImageView.layer.cornerRadius = characterImageView.frame.width / 4
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .specialCellBackground
        selectionStyle = .none
        
        characterStackView =  UIStackView(arrangedSubviews: [nameCharacterLabel,
                                                             speciesLabel,
                                                             genderLabel],
                                          axis: .vertical,
                                          spacing: 2)
        addSubview(characterImageView)
        addSubview(characterStackView)
    }
    
    func cellConfigure(model: Result) {
        nameCharacterLabel.text = model.name
        speciesLabel.text = model.species
        genderLabel.text = model.gender
        
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
            characterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            characterImageView.heightAnchor.constraint(equalToConstant: 120),
            characterImageView.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            characterStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            characterStackView.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 16),
            characterStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
