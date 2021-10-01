//
//  ExchangeTableFooterView.swift
//  EUExchange
//
//  Created by Shyam Kumar on 9/30/21.
//

import UIKit

struct ExchangeTableFooterModel {
    var totalEuros: Double
    var totalDollars: Double
    
    init(totalEuros: Double = 0, totalDollars: Double = 0) {
        self.totalEuros = totalEuros
        self.totalDollars = totalDollars
    }
}

class ExchangeTableFooterView: UITableViewHeaderFooterView {
    
    var model: ExchangeTableFooterModel = ExchangeTableFooterModel() {
        didSet {
            updateView()
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .bottom
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 16
        
        stack.addArrangedSubview(nameTextField)
        stack.addArrangedSubview(euroTextField)
        stack.addArrangedSubview(conversionLabel)
        stack.addArrangedSubview(dollarLabel)
        return stack
    }()
    
    lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .none
        field.font = .euRegular.withSize(14)
        field.textColor = .black
        field.text = "Total"
        field.isUserInteractionEnabled = false
        field.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return field
    }()
    
    lazy var euroTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .none
        field.font = .euRegular.withSize(14)
        field.textColor = .black
        field.text = "€0"
        field.isUserInteractionEnabled = false
        field.widthAnchor.constraint(equalToConstant: 45).isActive = true
        return field
    }()
    
    lazy var conversionLabel: UILabel = {
        let label = UILabel()
        label.text = "€\(Globals.exchangeRate) = $1"
        label.textColor = .euBlue
        label.font = .euRegular.withSize(12)
        label.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return label
    }()
    
    lazy var dollarLabel: UILabel = {
        let label = UILabel()
        label.text = "$0"
        label.textColor = .black
        label.font = .euRegular.withSize(14)
        return label
    }()
    
    func setupView() {
        addSubview(stackView)
        backgroundView = UIView()
    }
    
    func setupConstraints() {
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 36).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func updateView() {
        euroTextField.text = "€\(Globals.format(value: model.totalEuros))"
        dollarLabel.text = "$\(Globals.format(value: model.totalDollars))"
    }

}
