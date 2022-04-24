//
//  DetailsViewController.swift
//  RickAndMorty
//
//  Created by Тимур Ахметов on 24.04.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let genderLabel = UILabel(text: "GENDER:",
                                      font: .getRegularLabel18(),
                                      color: .specialBlueLabel)
    
    private let statusCharacterLabel = UILabel(text: "STATUS:",
                                               font: .getRegularLabel18(),
                                               color: .specialBlueLabel)
    
    private let locationLabel = UILabel(text: "LOCATION:",
                                        font: .getRegularLabel18(),
                                        color: .specialBlueLabel)
    
    private let genderTextLabel = UILabel(text: "",
                                          font: .getBoldLabel18(),
                                          color: .specialGreen)
    
    private let statusTextLabel = UILabel(text: "",
                                          font: .getBoldLabel18(),
                                          color: .specialGreen)
    
    private let locationTextLabel = UILabel(text: "",
                                            font: .getBoldLabel18(),
                                            color: .specialGreen)
    
    private let episodesLabel = UILabel(text: "EPISODES WITH THE CHARACTER:",
                                        font: .getRegularLabel18(),
                                        color: .specialBlueLabel)
    
    private let episodesTextLabel = UILabel(text: "0",
                                            font: .getBoldLabel18(),
                                            color: .specialGreen)
    
    private let moreTextLabel = UILabel(text: "Explorer more:",
                                        font: .getBoldLabel18(),
                                        color: .specialYellow)
    
    private var genderStackView = UIStackView()
    private var statusStackView = UIStackView()
    private var locationStackView = UIStackView()
    private var episodeStackView = UIStackView()
    
    private let idRandomCharacterCollectionView = "idRandomCharacterCollectionView"
    
    var charactersModel: Result?
    var resultsArray = [Result]()
    var randomCharacterArray = [Result]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setDelegates()
        setConstraints()
        setupCharacterInfo()
        getRandomCharacter()
    }
    
    private func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0.1516073942, green: 0.1516073942, blue: 0.1516073942, alpha: 1)
        
        collectionView.register(RandomCharacterCollectionViewCell.self, forCellWithReuseIdentifier: idRandomCharacterCollectionView)
       
        view.addSubview(scrollView)
        
        genderStackView =  UIStackView(arrangedSubviews: [genderLabel, genderTextLabel],
                                       axis: .horizontal,
                                       spacing: 2)
        
        statusStackView =  UIStackView(arrangedSubviews: [statusCharacterLabel, statusTextLabel],
                                       axis: .horizontal,
                                       spacing: 2)
        
        locationStackView =  UIStackView(arrangedSubviews: [locationLabel, locationTextLabel],
                                         axis: .horizontal,
                                         spacing: 1)
        episodeStackView =  UIStackView(arrangedSubviews: [episodesLabel, episodesTextLabel],
                                        axis: .horizontal,
                                        spacing: 1)
        
        scrollView.addSubview(characterImageView)
        scrollView.addSubview(genderStackView)
        scrollView.addSubview(statusStackView)
        scrollView.addSubview(locationStackView)
        scrollView.addSubview(episodeStackView)
        scrollView.addSubview(moreTextLabel)
        scrollView.addSubview(collectionView)
    }
    
    private func setDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupCharacterInfo() {
        guard let charactersModel = charactersModel else { return }
        title = charactersModel.name
        genderTextLabel.text = charactersModel.gender
        statusTextLabel.text = charactersModel.status
        locationTextLabel.text = charactersModel.location.name
        episodesTextLabel.text = "\(charactersModel.episode?.count ?? 0)"
        
        let url: URL = URL(string: "https://rickandmortyapi.com/api/character/avatar/\(charactersModel.id).jpeg")!
        
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
    
    private func getRandomCharacter() {
        
        for _ in 0...8 {
            let randomInt = Int.random(in: 0...resultsArray.count - 1)
            randomCharacterArray.append(resultsArray[randomInt])
        }
    }
}

//MARK: - UICollectionViewDataSource

extension DetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        randomCharacterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idRandomCharacterCollectionView, for: indexPath)
        as! RandomCharacterCollectionViewCell
        let characterModel = randomCharacterArray[indexPath.row]
        cell.cellConfigure(model: characterModel)
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension DetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let characterModel = randomCharacterArray[indexPath.row]
        
        let detailViewController = DetailsViewController()
        detailViewController.charactersModel = characterModel
        detailViewController.resultsArray = resultsArray
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.height,
               height: collectionView.frame.height)
    }
}

//MARK: - SetConstraints

extension DetailsViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            characterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            characterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            characterImageView.heightAnchor.constraint(equalToConstant: view.frame.width)
        ])
        
        NSLayoutConstraint.activate([
            genderStackView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 20),
            genderStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            genderStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            genderStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            statusStackView.topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: 20),
            statusStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            locationStackView.topAnchor.constraint(equalTo: statusStackView.bottomAnchor, constant: 20),
            locationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            episodeStackView.topAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 20),
            episodeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            episodeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            moreTextLabel.topAnchor.constraint(equalTo: episodeStackView.bottomAnchor, constant: 35),
            moreTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            moreTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            moreTextLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }
}
