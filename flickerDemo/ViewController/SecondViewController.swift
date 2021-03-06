//
//  SecondViewController.swift
//  flickerDemo
//
//  Created by william on 2020/5/26.
//  Copyright © 2020 william. All rights reserved.
//

import UIKit

protocol secondViewDelegate {
    func refrshMyView()
}

class SecondViewController: UIViewController {

    lazy var controller: SecondController = {
        return SecondController()
    }()
    
    var viewModel: SecondViewModel {
            return controller.viewModel
    }
    
    var input: searchInput?
    var type: VC_TYPE = .FAVORITE
    
    lazy var collectionView: UICollectionView = {
           let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
           collectionView.delegate = self
           collectionView.dataSource = self
           collectionView.translatesAutoresizingMaskIntoConstraints = false
           collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.cellIdentifier())
           collectionView.backgroundColor = .white
           view.addSubview(collectionView)
           NSLayoutConstraint.activate(collectionView.edgeConstraints(top: 0, left: 0, bottom: 0, right: 0))
           return collectionView
       }()
       
       lazy var loadingIdicator: UIActivityIndicatorView = {
           let indicator = UIActivityIndicatorView(style: .large)
           indicator.translatesAutoresizingMaskIntoConstraints = false
           indicator.hidesWhenStopped = true
           view.addSubview(indicator)
           NSLayoutConstraint.activate([
               indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
               indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
               ])
           return indicator
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBinding()
        if let input = input {
            controller.startWithInput(input: input)
        } else {
            controller.start()
        }
    }
    
    func initView() {
        let width = (view.bounds.width - 10) / 2
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: width, height: width)
            self.collectionView.setCollectionViewLayout(layout, animated: true)
        }
        if let input = input {
            navigationItem.title = "search result: \(input.content)"
        }
    }
    
    func initBinding() {
        viewModel.rowViewModels.addObserver(fireNow: false) { [weak self] (rowViewModels) in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.isLoading.addObserver { [weak self] (isLoading) in
            if isLoading {
                self?.loadingIdicator.startAnimating()
            } else {
                self?.loadingIdicator.stopAnimating()
            }
        }
    }


}

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource, secondViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.viewModel.rowViewModels.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowViewModel = self.viewModel.rowViewModels.value[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: controller.cellIdentifier(for: rowViewModel), for: indexPath)
        
        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: rowViewModel)
        }
        
        if let cell = cell as? PhotoCell {
            cell.delegate = self
            cell.type = type
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func refrshMyView() {
        self.controller.start()
    }
}
