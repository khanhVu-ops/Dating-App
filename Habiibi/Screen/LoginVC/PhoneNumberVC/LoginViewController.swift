//
//  LoginViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/22/22.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseAuth
class LoginViewController: BaseViewController {

    @IBOutlet weak var vEnterNumber: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var lbError: UILabel!
    let loginViewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpView()
        bindToViewModel()
        subscribeToLoading()
        // Do any additional setup after loading the view.
    }
    
    override func setUpView() {
        lbError.isHidden = true
        tfPhoneNumber.becomeFirstResponder()
        tfPhoneNumber.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:))))
        vEnterNumber.layer.cornerRadius = 15
        vEnterNumber.layer.shadowOffset = CGSize(width: 1, height: 1)
        vEnterNumber.layer.shadowRadius = 1
        vEnterNumber.layer.shadowColor = UIColor.gray.cgColor
        vEnterNumber.layer.masksToBounds = true
        
        btnContinue.layer.cornerRadius = 20

    }
    
    func subscribeToLoading() {
        loginViewModel.loadingBehavior.subscribe(onNext: { isLoading in
            if isLoading {
                self.showIndicator(withTitle: "", and: "")
            }else{
                self.hideIndicator()
            }
            
        })
        .disposed(by: disposeBag)
    }
    
    func bindToViewModel() {
        _ = tfPhoneNumber.rx.text.map{$0 ?? ""}.bind(to: loginViewModel.txtPhoneNumber).disposed(by: disposeBag)
        _ = loginViewModel.isValidPhoneNumber.subscribe({ [weak self] isValid in
            guard let isValid = isValid.element else {
                return
            }
            self?.btnContinue.isEnabled = isValid
            self?.btnContinue.backgroundColor = isValid ? .blue : UIColor.blue.withAlphaComponent(0.3)
        })
        .disposed(by: disposeBag)
        
    }
    
    @IBAction func didTapBtnBack(_ sender: Any) {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapBtnContinue(_ sender: Any) {
        loginViewModel.signInWithPhoneNumber(vc: self)
        
    }
    
    
    @IBAction func didTapBtnLoginWithFb(_ sender: Any) {
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfPhoneNumber.resignFirstResponder()
    }
}
