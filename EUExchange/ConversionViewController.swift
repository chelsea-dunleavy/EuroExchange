//
//  ConversionViewController.swift
//  EUExchange
//
//  Created by Shyam Kumar on 9/27/21.
//

import UIKit

class ConversionViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    lazy var topStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(addButton)
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = ViewController.combineAttrs(str1: "EU", str2: "Exchange", attr1: boldAttributes, attr2: thinAttributes)
        label.textAlignment = .left
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var exchangeTableView: ExchangeTableView = {
        let view = ExchangeTableView()
        view.model = ExchangeTableViewModel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var boldAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.euBold.withSize(24),
        .foregroundColor: UIColor.black
    ]
    
    var thinAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.euLight.withSize(24),
        .foregroundColor: UIColor.black
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()

        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(topStack)
        view.addSubview(exchangeTableView)
        view.hideKeyboardWhenTappedAround()
    }
    
    func setupConstraints() {
        topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        topStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        topStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        exchangeTableView.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 16).isActive = true
        exchangeTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        exchangeTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        exchangeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 12).isActive = true
    }
    
    @objc func addTapped() {
        exchangeTableView.addNewCell()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
