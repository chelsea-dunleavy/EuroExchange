//
//  ExchangeTableView.swift
//  EUExchange
//
//  Created by Shyam Kumar on 9/27/21.
//

import UIKit

struct ExchangeTableViewModel {
    var cells: [ExchangeTableViewCellModel]
    
    init(cells: [ExchangeTableViewCellModel] = []) {
        self.cells = cells
    }
}

class ExchangeTableView: UIView {
    
    var model: ExchangeTableViewModel = ExchangeTableViewModel() {
        didSet {
            updateView()
        }
    }
    
    let cellId: String = "exchange"
    let footerId: String = "footer"
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .singleLine
        table.register(ExchangeTableViewCell.self, forCellReuseIdentifier: cellId)
        table.register(ExchangeTableFooterView.self, forHeaderFooterViewReuseIdentifier: footerId)
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = false
        table.tableFooterView = UIView(frame: .zero)
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .clear
        addSubview(tableView)
        hideKeyboardWhenTappedAround()
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateView() {
        tableView.reloadData()
    }
    
    func cellAmtChanged() {
        var euroSum: Double = 0
        var dollarAmt: Double = 0
        for model in model.cells {
            if model.isCellEnabled {
                euroSum += model.euros
                dollarAmt += model.dollarAmt
            }
        }
        
        if let footView = tableView.footerView(forSection: 0) as? ExchangeTableFooterView {
            footView.model.totalEuros = euroSum
            footView.model.totalDollars = dollarAmt
        }
    }

}

extension ExchangeTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ExchangeTableViewCell {
            cell.model = model.cells[indexPath.row]
            cell.model.amtChangedCompletion = cellAmtChanged
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if model.cells.count > 0 {
            if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerId) as? ExchangeTableFooterView {
                return view
            }
        }

        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if model.cells.count > 0 {
            return 30
        }
        
        return 0
    }
    
    func addNewCell() {
        model.cells.append(ExchangeTableViewCellModel())
        tableView.reloadRows(at: tableView.indexPathsForVisibleRows ?? [], with: .automatic)
        
    }
    
}

class ExchangeTableViewCellModel {
    var name: String
    var euros: Double
    var dollarAmt: Double = 0
    var amtChangedCompletion: () -> Void = { return }
    var isCellEnabled = true
    
    init(name: String = "", euros: Double = 0) {
        self.name = name
        self.euros = euros
    }
}

class ExchangeTableViewCell: UITableViewCell {
    var model: ExchangeTableViewCellModel = ExchangeTableViewCellModel() {
        didSet {
            updateView()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var circleSelect: CircleSelect = {
        let view = CircleSelect()
        view.selectionChanged = selectionChanged(to:)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()
    
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
        field.placeholder = "Name"
        field.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return field
    }()
    
    lazy var euroTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .none
        field.font = .euRegular.withSize(14)
        field.textColor = .black
        field.placeholder = "EUR"
        field.widthAnchor.constraint(equalToConstant: 45).isActive = true
        field.tag = 1
        field.delegate = self
        field.keyboardType = .numbersAndPunctuation
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
        backgroundColor = .clear
        contentView.addSubview(circleSelect)
        contentView.isUserInteractionEnabled = true
        contentView.addSubview(stackView)
        hideKeyboardWhenTappedAround()
    }
    
    func setupConstraints() {
        circleSelect.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        circleSelect.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        stackView.bottomAnchor.constraint(equalTo: circleSelect.bottomAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: circleSelect.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: circleSelect.rightAnchor, constant: 16).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    func updateView() {
    }
    
    func selectionChanged(to: Bool) {
        model.isCellEnabled = !to
        model.amtChangedCompletion()
        if !to {
            enableCell()
        } else {
            disableCell()
        }
    }
    
    func disableCell() {
        nameTextField.isUserInteractionEnabled = false
        nameTextField.textColor = .gray
        
        euroTextField.isUserInteractionEnabled = false
        euroTextField.textColor = .gray
        
        conversionLabel.textColor = .gray
        
        dollarLabel.textColor = .gray
    }
    
    func enableCell() {
        nameTextField.isUserInteractionEnabled = true
        nameTextField.textColor = .black
        
        euroTextField.isUserInteractionEnabled = true
        euroTextField.textColor = .black
        
        conversionLabel.textColor = .euBlue
        
        dollarLabel.textColor = .black
    }
}

extension ExchangeTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            if let text = textField.text,
               !(textField.text?.isEmpty ?? true) {
                if let textDouble = Double(text.replacingOccurrences(of: "€", with: "")) {
                    model.euros = textDouble
                    model.dollarAmt = textDouble * Globals.exchangeRate
                    dollarLabel.text = "$\(Globals.format(value: textDouble * Globals.exchangeRate))"
                }
                
                if !text.contains("€") {
                    textField.text = "€\(text)"
                }
                
                model.amtChangedCompletion()
            }
        }
    }
}
