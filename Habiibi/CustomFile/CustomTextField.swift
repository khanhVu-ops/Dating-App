//
//  CustomTextField.swift
//  Habiibi
//
//  Created by KhanhVu on 6/22/22.
//

import UIKit
protocol CustomTextFieldDelegate{
    func textFieldDidDelete(_ textField: CustomTextField)
}
class CustomTextField: UITextField {
    weak var previousTextField: UITextField?
    weak var nextTextFiled: UITextField?
    var myCustomTextFieldDelegate : CustomTextFieldDelegate?
    
    var check = false
    
    override func deleteBackward() {
        super.deleteBackward()
        
        print("detete: \(String(describing: text))")
        if check {
            check = false
            
        }else {
            myCustomTextFieldDelegate?.textFieldDidDelete(self)
            previousTextField?.becomeFirstResponder()
        }
        
    }
}
