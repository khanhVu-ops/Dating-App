//
//  VerifyCodeViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/22/22.
//

import UIKit

class VerifyCodeViewController: BaseViewController {

    @IBOutlet weak var stvOTP: OTPStackView!
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var lbError: UILabel!
    let verifyCodeViewModel = VerifyCodeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
    }
    
    override func setUpView() {
        
        verifyCodeViewModel.stvOTP = stvOTP
        
        btnAgree.layer.cornerRadius = 25
        updateButtonUI(btnAgree, enable: false, color: .blue)
        showError(lbError: lbError, enable: false, text: "")
        let otpFont = UIFont(name: "System", size: 20)
        stvOTP.configTextFieldView(borderStyle: .none,
                                   font: otpFont,
                                   editingBorderColor: UIColor.blue,
                                   nonEditingborderColor: .gray,
                                   borderWidth: 1,
                                   cornerRadius: 8)
        
        stvOTP.otpValueDidChanged = {[weak self] in
            guard let self = self else { return}
            
            self.updateButtonUI(self.btnAgree, enable: $0.count == 6, color: .blue)
        }
        
        
        stvOTP.textFieldArray[0].becomeFirstResponder()
    }
//    func updateButtonUI(_ btn: UIButton, enable: Bool, color: UIColor) {
//        btn.isEnabled = enable
//        btn.backgroundColor = enable ? color : color.withAlphaComponent(0.3)
//    }
    
    
    @IBAction func didTapbtnBack(_ sender: Any) {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapBtnVerify(_ sender: Any) {
        if verifyCodeViewModel.checkOTPSuccessfull() {
            showError(lbError: lbError, enable: false, text: "")
            let st = UIStoryboard(name: "Main", bundle: nil)
            if verifyCodeViewModel.checkAccountRegisted() {
                let vcHome = st.instantiateViewController(withIdentifier: "CustomTabbarController") as! CustomTabbarController
                self.navigationController?.pushViewController(vcHome, animated: true)
            }else {
                let vcGender = st.instantiateViewController(withIdentifier: "GenderSignUpViewController") as! GenderSignUpViewController
               
                self.navigationController?.pushViewController(vcGender, animated: true)
            }
        }else {
            showError(lbError: lbError, enable: true, text: "Error: Verify code incorrect!")
        }
    }
}
