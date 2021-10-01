//
//  Globals.swift
//  EUExchange
//
//  Created by Shyam Kumar on 9/27/21.
//

import Foundation
import UIKit

class Globals {
    static var exchangeRate: Double = 1.17
    
    static func format(value: Double) -> String {
        return String(format: "%.2f", value)
    }
}

extension UIView {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}
