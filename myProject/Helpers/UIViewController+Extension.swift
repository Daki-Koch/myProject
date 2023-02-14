//
//  UIViewController+Extension.swift
//  myProject
//
//  Created by David Koch on 14.02.23.
//

import Foundation
import UIKit

extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
