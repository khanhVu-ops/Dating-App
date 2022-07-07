//
//  OTPStackView.swift
//  Habiibi
//
//  Created by KhanhVu on 6/22/22.
//

import UIKit

class OTPStackView: UIStackView {
    var textFieldArray = [CustomTextField]()
    var editingBorderColor: UIColor? = nil
    var nonEditingborderColor: UIColor? = nil
    var checkFieldFinally = true
    var otpValueDidChanged: ((String) -> ())? = nil
//    var otpValueDidChanged: ((String) -> ())? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTextFields()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setTextFields()
    }
    
    func setTextFields() {
        textFieldArray.forEach {
            $0.removeFromSuperview()
        }
        textFieldArray = []
        for i in 0..<6 {
            let field = CustomTextField()
            textFieldArray.append(field)
            addArrangedSubview(field)
            field.myCustomTextFieldDelegate = self
            field.delegate = self
            i != 0 ? (field.previousTextField = textFieldArray[i-1]) : ()
            i != 0 ? (textFieldArray[i-1].nextTextFiled = textFieldArray[i]) : ()
        }
        configTextFieldView()
    }
    
    func configTextFieldView(backgroundColor: UIColor = .white,
                             textAlignment: NSTextAlignment = .center,
                             borderStyle: UITextField.BorderStyle = .roundedRect,
                             font: UIFont? = .systemFont(ofSize: 20),
                             keyboardType: UIKeyboardType = .numberPad,
                             editingBorderColor: UIColor? = nil,
                             nonEditingborderColor: UIColor? = nil,
                             borderWidth: CGFloat = 0,
                             cornerRadius: CGFloat = 0) {
        
        textFieldArray.forEach {
            $0.backgroundColor = backgroundColor
            $0.textAlignment = textAlignment
            $0.borderStyle = borderStyle
            $0.font = font
            $0.keyboardType = .numberPad
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = borderWidth
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.layer.cornerRadius = cornerRadius
            $0.layer.borderColor = nonEditingborderColor?.cgColor
        }
        self.nonEditingborderColor = nonEditingborderColor
        self.editingBorderColor = editingBorderColor
    }
    
    @objc func textFieldEditChanged(_ textField: UITextField) {
        otpValueDidChanged?(getOTPString())
    }
    
    func getOTPString() -> String {
        let otps = textFieldArray.compactMap({ $0.text}).joined()
        
        return otps
    }
    
}
extension OTPStackView: CustomTextFieldDelegate {
    func textFieldDidDelete(_ textField: CustomTextField) {
//        print("text: \(textField.text)")
        if textField.text?.isEmpty == true {
            textField.previousTextField?.text = ""
        }
        textField.text = ""
        
    }
}
extension OTPStackView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let shoudEdit = textFieldArray.first(where: { $0.text?.isEmpty == true}) ?? textFieldArray[5]

        
        if shoudEdit == textField {
            
            textField.layer.borderColor = editingBorderColor?.cgColor
            return true
        } else {
            shoudEdit.becomeFirstResponder()
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = nonEditingborderColor?.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let field = textField as? CustomTextField else {
            return true
        }
        if string.isEmpty == false {
            field.text = string
            textFieldEditChanged(field)
            if  let nextTF = field.nextTextFiled {
                nextTF.becomeFirstResponder()
                checkFieldFinally = true
                
            }else {
                field.check = true
                textField.resignFirstResponder()
//                otpValueDidChanged?(getOTPString())
            }
            
//            textFieldEditChanged(field)
            
            return false
        }
        return true
    }
}
