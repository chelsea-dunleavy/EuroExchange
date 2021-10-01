//
//  CircleSelect.swift
//  EUExchange
//
//  Created by Shyam Kumar on 9/27/21.
//

import UIKit

class CircleSelect: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var isSelected: Bool = false {
        didSet {
            updateView()
        }
    }
    
    lazy var innerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        view.layer.cornerRadius = 5
        view.backgroundColor = .black
        view.alpha = 0
        return view
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
        layer.cornerRadius = 10
        layer.borderColor = UIColor.black.withAlphaComponent(0.22).cgColor
        layer.borderWidth = 1
        addSubview(innerView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tapGesture)
    }
    
    func setupConstraints() {
        innerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        innerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func updateView() {
        if isSelected {
            innerView.alpha = 1
        } else {
            innerView.alpha = 0
        }
    }
    
    @objc func tapped() {
        isSelected = !isSelected
    }

}
