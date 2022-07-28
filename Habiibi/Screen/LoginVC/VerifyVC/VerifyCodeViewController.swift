//
//  VerifyCodeViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/22/22.
//

import UIKit
import FirebaseAuth
import Firebase
import Toast_Swift
import FirebaseDatabase
import RxSwift
class VerifyCodeViewController: BaseViewController {
    var ref: DatabaseReference!

    
    @IBOutlet weak var stvOTP: OTPStackView!
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var lbError: UILabel!
    let verifyCodeViewModel = VerifyCodeViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        subscribeToLoading()
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
    
    func subscribeToLoading() {
        verifyCodeViewModel.loadingBehavior.subscribe(onNext: { isLoading in
            if isLoading {
                self.showIndicator(withTitle: "", and: "")
            }else{
                self.hideIndicator()
            }
            
        })
        .disposed(by: disposeBag)
    }
    
    
    @IBAction func didTapbtnBack(_ sender: Any) {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapBtnVerify(_ sender: Any) {
        verifyCodeViewModel.verifyPhoneNumber(vc: self)
        
    }
}
