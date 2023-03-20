//
//  ViewController.swift
//  Gallery
//
//  Created by Saida Yessirkepova on 20.02.2023.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

class MainViewController: UIViewController {
    
    private var imageModelList: [ImageModel] = []
    
    private lazy var  contentView = UIView()
    private var mediaType: MediType = .image
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [MediType.image.rawValue, MediType.video.rawValue])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.resignFirstResponder()
        return searchBar
    }()
    
    private lazy var mediaCollectionView: UICollectionView = {
     let layout = UICollectionViewFlowLayout()
     let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Identifiers.mediaCollectionViewCell)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .systemBackground
        configureNavBar()

        
        mediaCollectionView.dataSource = self
        mediaCollectionView.delegate = self
        searchBar.delegate = self
        
        APICaller.shared.delegate = self
        APICaller.shared.fetchRequest()
        
        setupViews()
        setupConstraints()
        
       
    }
}
//MARK: - Private view controller  methods

private extension MainViewController {
    func configureNavBar() {
        navigationItem.title = "Movies & Images"
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex  {
        case 0: mediaType = .image
        case 1: mediaType = .video
        default: return
        }
        mediaCollectionView.reloadData()
    }
    
}
extension MainViewController: APICallerDelegate {
    func didFailtWithError(_ error: Error) {
        print("Following ERROR appeared", error
        )
    }
    
    func didUpdateModelList(with modelList: [ImageModel]) {
        self.imageModelList = modelList
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadData()
        }
    }
    
    
}
//MARK: - Collection View data sourse methods

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.mediaCollectionViewCell, for: indexPath) as! MediaCollectionViewCell
        if mediaType == .image {
            cell.backgroundColor = Constants.Colors.imageCell
        } else {
            cell.backgroundColor = Constants.Colors.videoCell
            
        }
        cell.configure(with: imageModelList[indexPath.row], mediaType)
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    
}

//MARK: - Collection View Flow Delegate methods

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width/2.06
       return CGSize(width: width, height: width*1.12)
        
    }
}

//MARK: - Search bar delegate methods
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchBar.text?.replacingOccurrences(of: " ", with: "+")
        imageModelList.removeAll()
        APICaller.shared.fetchRequest(with: query ?? "")
    }
}


//MARK: - Setup views and constraints methods

private extension MainViewController {
    func setupViews(){
        view.addSubview(contentView)
        contentView.addSubview(searchBar)
        contentView.addSubview(segmentedControl)
        contentView.addSubview(mediaCollectionView)
    }
    func setupConstraints(){
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        segmentedControl.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.trailing.equalToSuperview()
        
        }
        searchBar.searchTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
