//
//  SecondController.swift
//  flickerDemo
//
//  Created by william on 2020/5/26.
//  Copyright © 2020 william. All rights reserved.
//

import Foundation

class SecondController {
    let viewModel: SecondViewModel
    let type: VC_TYPE
    
    init(viewModel: SecondViewModel = SecondViewModel(), type: VC_TYPE) {
        self.viewModel = viewModel
        self.type = type
    }
    
    func start() {
        self.buildRowWithDatas(photoDatas: myFavorite.sharedInstance.getAllData())
    }
    
    func startWithInput(input: searchInput) {
        viewModel.isLoading.value = true
        CloudAPIService.shared.searchPhotos(input: input) { (result) in
            self.viewModel.isLoading.value = false
            switch result {
            case .success(let searchData):
                self.buildRows(searchData: searchData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func buildRowWithDatas(photoDatas: [PhotoDatas]) {
        var rowModels = [RowViewModel]()
        for photo in photoDatas {
            if let url = photo.imageUrl, let title = photo.title, let id = photo.id {
                let photoCell = photoCellModel.init(photo: nil, id: id, photoURL: url, title: title, type: type)
                rowModels.append(photoCell)
            }
        }
        
        viewModel.rowViewModels.value = rowModels
    }
    
    func buildRows(searchData: SearchData) {
        var rowModels = [RowViewModel]()
        
        for photo in searchData.photos.photo {
            let photoCell = photoCellModel.init(photo: photo, id: photo.id, photoURL: photo.imageUrl, title: photo.title, type: type)
            rowModels.append(photoCell)
        }
        
        viewModel.rowViewModels.value = rowModels
    }
    
    func cellIdentifier(for viewModel: RowViewModel) -> String {
        switch viewModel {
        case is photoCellModel:
            return PhotoCell.cellIdentifier()
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
}
