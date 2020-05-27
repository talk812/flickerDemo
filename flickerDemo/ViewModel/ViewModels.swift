//
//  ViewModels.swift
//  flickerDemo
//
//  Created by william on 2020/5/26.
//  Copyright © 2020 william. All rights reserved.
//

import Foundation
import UIKit

protocol RowViewModel {
    
}

class FirstViewModel {
    let isDone = Observable<Bool>(value: false)
}

class SecondViewModel {
    let rowViewModels = Observable<[RowViewModel]>(value: [])
    let isLoading = Observable<Bool>(value: false)
}

class photoCellModel: RowViewModel {
    let photo: Photo?
    let id: String
    let photoURL: URL
    let title: String
    let favorite: Observable<Bool>
    let isLoading = Observable<Bool>(value: false)
    init(photo: Photo?, id: String,photoURL: URL, title: String,favorite: Observable<Bool> = Observable<Bool>(value: false)) {
        self.photo = photo
        self.id = id
        self.photoURL = photoURL
        self.title = title
        self.favorite = favorite
    }
}


