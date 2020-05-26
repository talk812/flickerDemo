//
//  CellConfiguration.swift
//  O-Fit
//
//  Created by william on 2020/2/11.
//  Copyright © 2020 O-Fit. All rights reserved.
//

import Foundation

protocol CellConfigurable {
    func setup(viewModel: RowViewModel)
    func setupConstraint()
    func setupInitialView()
}
