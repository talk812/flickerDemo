//
//  FirstViewController.swift
//  flickerDemo
//
//  Created by william on 2020/5/26.
//  Copyright © 2020 william. All rights reserved.
//

import UIKit

enum TEXTFIELD_TYPE: Int {
    case CONTENT
    case PERPAGE
}

struct searchInput {
    var content: String
    var perPage: String
}

class FirstViewController: UIViewController {
    
    lazy var controller: FirstController = {
        return FirstController()
    }()
    
    var viewModel: FirstViewModel {
            return controller.viewModel
    }
        
    var input: searchInput = searchInput.init(content: "", perPage: "")
    
    lazy var contentTextField: UITextField = {
        let myTextField = UITextField()
        myTextField.translatesAutoresizingMaskIntoConstraints = false
        myTextField.borderStyle = .roundedRect
        myTextField.delegate = self
        myTextField.tag = TEXTFIELD_TYPE.CONTENT.rawValue
        myTextField.addTarget(self, action: #selector(FirstViewController.textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(myTextField)
        NSLayoutConstraint.activate([myTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     myTextField.bottomAnchor.constraint(equalTo: perPageTextField.topAnchor, constant: -20),
                                     myTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                                     myTextField.heightAnchor.constraint(equalToConstant: 50)])
        return myTextField
    }()
    
    lazy var perPageTextField: UITextField = {
        let myTextField = UITextField()
        myTextField.translatesAutoresizingMaskIntoConstraints = false
        myTextField.keyboardType = .numberPad
        myTextField.borderStyle = .roundedRect
        myTextField.delegate = self
        myTextField.tag = TEXTFIELD_TYPE.PERPAGE.rawValue
        myTextField.addTarget(self, action: #selector(FirstViewController.textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(myTextField)
        NSLayoutConstraint.activate([myTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     myTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     myTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                                     myTextField.heightAnchor.constraint(equalToConstant: 50)])
        return myTextField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundColor(.gray, for: .normal)
        button.setBackgroundColor(.blue, for: .selected)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.isEnabled = false
        view.addSubview(button)
        NSLayoutConstraint.activate([button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     button.topAnchor.constraint(equalTo: perPageTextField.bottomAnchor, constant: 20),
                                     button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                                     button.heightAnchor.constraint(equalToConstant: 50)])
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearInput()
    }

    func initView() {
        contentTextField.placeholder = "欲搜尋內容"
        perPageTextField.placeholder = "每頁呈現數量"
        searchButton.setTitle("搜尋", for: .normal)
        searchButton.addTarget(self, action: #selector(startToSearch), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyBoard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func initBinding() {
        viewModel.isDone.addObserver(fireNow: false) { [weak self] (isDone) in
            self?.searchButton.isEnabled = isDone
            self?.searchButton.isSelected = isDone
        }
    }
    
    @objc func hideKeyBoard() -> Void {
        self.view.endEditing(true)
    }
    
    @objc func startToSearch() {
        guard contentTextField.text?.isEmpty == false && perPageTextField.text?.isEmpty == false else {
            viewModel.isDone.value = false
            return
        }
        if let searchVC = self.storyboard?.instantiateViewController(identifier: "SecondViewController") as? SecondViewController,
            viewModel.isDone.value == true {
            searchVC.input = input
            searchVC.type = .SEARCH
            navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    
    func clearInput() {
        contentTextField.text = ""
        perPageTextField.text = ""
        input.content = ""
        input.perPage = ""
        viewModel.isDone.value = false
        contentTextField.becomeFirstResponder()
    }
}

extension FirstViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch TEXTFIELD_TYPE.init(rawValue: textField.tag) {
        case .CONTENT:
            input.content = textField.text ?? ""
            break
        case .PERPAGE:
            input.perPage = textField.text ?? ""
            break
        case .none:
            fatalError()
        }
        
        guard input.content.isEmpty == false else {
            viewModel.isDone.value = false
            return
        }
        guard input.perPage.isEmpty == false && input.perPage.isNumeric else {
            viewModel.isDone.value = false
            return
        }
        viewModel.isDone.value = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
