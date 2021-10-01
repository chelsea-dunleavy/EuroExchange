//
//  ViewController.swift
//  EUExchange
//
//  Created by Shyam Kumar on 9/27/21.
//

import UIKit

class ViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    lazy var launchLabel: UILabel = {
        let label = UILabel()
        label.attributedText = ViewController.combineAttrs(str1: "EU", str2: "Exchange", attr1: boldAttributes, attr2: thinAttributes)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var boldAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.euBold.withSize(30),
        .foregroundColor: UIColor.black
    ]
    
    var thinAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.euLight.withSize(30),
        .foregroundColor: UIColor.black
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveExchangeRate {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1, animations: {
                    self.launchLabel.alpha = 0
                }, completion: { fin in
                    if fin {
                        self.navigationController?.pushViewController(ConversionViewController(), animated: false)
                    }
                })
            }
        }
    }
    
    func setupView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        view.addSubview(launchLabel)
    }
    
    func setupConstraints() {
        launchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        launchLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        launchLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    }
    
    static func combineAttrs(str1: String, str2: String, attr1: [NSAttributedString.Key: Any], attr2: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        let attrStr1 = NSMutableAttributedString(string: str1, attributes: attr1)
        let attrStr2 = NSMutableAttributedString(string: str2, attributes: attr2)
        attrStr1.append(attrStr2)
        return attrStr1
    }
    
    func retrieveExchangeRate(completion: @escaping () -> Void) {
        let session = URLSession.shared
        if let url = URL(string: "http://api.exchangeratesapi.io/v1/latest?access_key=48d0032f184d7508e339415d7cb3529e&symbols=USD") {
            session.dataTask(with: url) { data, response, error in
                if error != nil {
                    completion()
                }
                
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let ratesDict = json["rates"] as? [String: Any],
                           let rate = ratesDict["USD"] as? Double,
                           let formattedRate = Double(Globals.format(value: rate)) {
                            Globals.exchangeRate = formattedRate
                            completion()
                        } else {
                            completion()
                        }
                    } catch {
                        completion()
                    }
                }
                
            }.resume()
        } else {
            completion()
        }
    }
}

