//
//  LoginViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/22/22.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var vEnterNumber: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnLoginWithFb: UIButton!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var lbError: UILabel!
    let loginViewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpView()
        // Do any additional setup after loading the view.
    }
    
    override func setUpView() {
        showError(lbError: lbError, enable: false, text: "")
        updateButtonUI(btnContinue, enable: false, color: .blue)
        tfPhoneNumber.becomeFirstResponder()
        tfPhoneNumber.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:))))
        vEnterNumber.layer.cornerRadius = 15
        vEnterNumber.layer.shadowOffset = CGSize(width: 1, height: 1)
        vEnterNumber.layer.shadowRadius = 1
        vEnterNumber.layer.shadowColor = UIColor.gray.cgColor
        vEnterNumber.layer.masksToBounds = true
        
        btnContinue.layer.cornerRadius = 20
        btnLoginWithFb.layer.cornerRadius = 20
        btnLoginWithFb.layer.borderWidth = 0.5
        btnLoginWithFb.layer.borderColor = UIColor.gray.cgColor
        loginViewModel.tfEnter = tfPhoneNumber
//        loginViewModel.btnContinue = btnContinue
        
    }
    @IBAction func didTapBtnBack(_ sender: Any) {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapBtnContinue(_ sender: Any) {
        
        if loginViewModel.checkPhoneNumberIsValid() {
            let st = UIStoryboard(name: "Main", bundle: nil)
            let vcVerify = st.instantiateViewController(withIdentifier: "VerifyCodeViewController") as! VerifyCodeViewController
            self.navigationController?.pushViewController(vcVerify, animated: true)
        }else {
            showError(lbError: lbError, enable: true, text: "Phone number is invalid!")
        }
        
    }
    
    
    @IBAction func didTapBtnLoginWithFb(_ sender: Any) {
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard  let text = textField.text else {
            return false
        }
        let full_text = text + string
        if full_text.first == "0" {
            if full_text.count > 9 {
                updateButtonUI(btnContinue, enable: true, color: .blue)
            }else {
                updateButtonUI(btnContinue, enable: false, color: .blue)
            }
            
        }else {
            if full_text.count >= 9 {
                updateButtonUI(btnContinue, enable: true, color: .blue)
            }else {
                updateButtonUI(btnContinue, enable: false, color: .blue)
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfPhoneNumber.resignFirstResponder()
    }
}
