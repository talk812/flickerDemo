//
//  SecondViewController.swift
//  flickerDemo
//
//  Created by william on 2020/5/26.
//  Copyright © 2020 william. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
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
        // Do any additional setup after loading the view.
    }


}

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell.init()
    }
}
