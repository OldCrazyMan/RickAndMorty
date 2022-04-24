//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Тимур Ахметов on 24.04.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 150
        tableView.backgroundColor = .specialCellBackground
        tableView.register(СharacterTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var characterCount = 0
    var page = 1
    var nextPage = true
    
    var characters: Character?
    var resultsArray = [Result]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBarSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCharacters(page: page)
        tableView.reloadData()
        
        setupViews()
        setupDelegate()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialCellBackground
        
        view.addSubview(tableView)
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func navigationBarSettings() {
        
        if let navController = navigationController {
            navigationItem.backButtonTitle = ""
            navController.navigationBar.barStyle = .black
            navController.navigationBar.tintColor = .specialYellow
            navController.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LabGrotesqueMono-Bold", size: 20)!, .foregroundColor: UIColor.specialBlueLabel]
            
            let imageLogo = UIImage(named: "Logo")
            
            let heightNavBar = navController.navigationBar.frame.height
            let widthNavBar = navController.navigationBar.frame.width
            
            let widthForView = widthNavBar * 0.4
            
            let logoConteiner = UIView(frame: CGRect(x: 0, y: 0, width: widthForView, height: heightNavBar))
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: widthForView, height: heightNavBar))
            imageView.image = imageLogo
            imageView.contentMode = .scaleAspectFill
            logoConteiner.addSubview(imageView)
            
            navigationItem.titleView = logoConteiner
        }
    }
}

//MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! СharacterTableViewCell
        let characterModel = resultsArray[indexPath.row]
        cell.cellConfigure(model: characterModel)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterModel = resultsArray[indexPath.row]
        let detailViewController = DetailsViewController()
        detailViewController.charactersModel = characterModel
        detailViewController.resultsArray = resultsArray
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let height = scrollView.frame.size.height
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if contentOffset > contentHeight - height {
            guard nextPage else { return }
            page += 1
            fetchCharacters(page: page)
        }
    }
}

//MARK: - FetchCharacters

extension MainViewController {
    
    func fetchCharacters(page: Int) {
        
        NetworkDataFetch.shared.fetchCharacters(page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if self.resultsArray.count < self.characterCount { self.nextPage = false }
                
                self.resultsArray += response.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    let _ = ActivityIndicator.shared.customActivityIndicatory(self.view, startAnimate: false)
                }
            case .failure(_):
                let _ = ActivityIndicator.shared.customActivityIndicatory(self.view, startAnimate: true)
                self.alertOk(title: "Connect error", message: "Please, check your internet connection.")
            }
        }
    }
    
    func fetchCharacterCount() {
        NetworkDataFetch.shared.fetchCharacterCount() { [weak self] result in
            guard let self =  self else { return }
            
            switch result {
            case .success(let response):
                self.characterCount = response.info.count
            case .failure(_):
                return
            }
        }
    }
}

//MARK: - SetConstraints

extension MainViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
