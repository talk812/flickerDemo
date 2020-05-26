//
//  PhotoCell.swift
//  flickerDemo
//
//  Created by william on 2020/5/26.
//  Copyright © 2020 william. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell, CellConfigurable {
    
    var viewModel: photoCellModel?
    
    lazy var loadingIdicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        contentView.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        return indicator
    }()
    
    lazy var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
                                     imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
                                     imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                                     imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)])
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .center
        contentView.addSubview(label)
        NSLayoutConstraint.activate([label.heightAnchor.constraint(equalToConstant: 44),
                                     label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
                                     label.topAnchor.constraint(equalTo: myImageView.bottomAnchor, constant: 10),
                                     label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)])
        
        return label
    }()
    
    lazy var starButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "heart"), for: .selected)
        button.tintColor = .lightGray
        myImageView.addSubview(button)
        NSLayoutConstraint.activate([button.heightAnchor.constraint(equalToConstant: 30),
                                     button.widthAnchor.constraint(equalToConstant: 30),
                                     button.topAnchor.constraint(equalTo: myImageView.topAnchor, constant: 0),
                                     button.trailingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 0)])
        return button
    }()
    
    func setup(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? photoCellModel else { return }
        self.viewModel = viewModel
        
        viewModel.isLoading.addObserver { [weak self] (isLoading) in
            DispatchQueue.main.async {
                if isLoading {
                    self?.loadingIdicator.startAnimating()
                } else {
                    self?.loadingIdicator.stopAnimating()
                }
            }
        }
        
        viewModel.isLoading.value = true
        
        DispatchQueue.global().async {
            CloudAPIService.shared.downloadImage(url: viewModel.photoURL) { [weak self] (image) in
                DispatchQueue.main.async {
                    if let image = image {
                        self?.myImageView.image = image
                    } 
                    viewModel.isLoading.value = false
                }
            }
        }
        self.titleLabel.text = viewModel.title
        
        viewModel.favorite.addObserver { [weak self] (favorite) in
            if favorite {
                self?.starButton.tintColor = .blue
            } else {
                self?.starButton.tintColor = .lightGray
            }
        }
        
        if viewModel.type == .FAVORITE {
            viewModel.favorite.value = true
        }
        setNeedsLayout()
    }
    
    func setupConstraint() {
        
    }
    
    func setupInitialView() {
        starButton.addTarget(self, action: #selector(favoriteClick(sender:)), for: .touchUpInside)
    }
    
    @objc func favoriteClick(sender: UIButton) {
       
        sender.isSelected = !sender.isSelected
        self.viewModel?.favorite.value = sender.isSelected
        
        if self.viewModel?.type == .FAVORITE {
            if let id = self.viewModel?.id {
                myFavorite.sharedInstance.removeDataByID(id: id)
                NotificationCenter.default.post(name: Notification.Name.init(TAB_BAR_VC), object: nil)
            }
        } else {
            if let photo = self.viewModel?.photo {
                myFavorite.sharedInstance.insertData(photo: photo)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
        setupInitialView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.isLoading.removeObserver()
        self.myImageView.image = nil
    }
}
