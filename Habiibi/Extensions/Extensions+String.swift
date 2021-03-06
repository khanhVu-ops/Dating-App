//
//  Extensions+String.swift
//  Habiibi
//
//  Created by KhanhVu on 6/28/22.
//

import Foundation
import UIKit

extension String {
    //Note: Can check lai sdt
    func isValidPhoneNumber() -> Bool {
        let regEx = "^[0-9+]{0,1}+[0-9]{8,11}$"
        
        let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
        return phoneCheck.evaluate(with: self)
    }
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
