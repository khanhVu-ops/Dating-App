//
//  FillNameSignUpViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/23/22.
//

import UIKit
import RxSwift
import RxCocoa

class FillNameSignUpViewController: BaseViewController {

    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    let disposeBag = DisposeBag()
    let fillNameViewModel = FillNameSignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:))))
        
        setUpView()
        subscribeToLoading()
        bindToFillNameViewModel()
        subscribeIsBtnContinue()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func setUpView() {
        tfFirstName.delegate = self
        tfLastName.delegate = self
        btnNext.layer.cornerRadius = 25
        
    }
    func bindToFillNameViewModel() {
        tfFirstName.rx.text.orEmpty.bind(to: fillNameViewModel.txtFirstName).disposed(by: disposeBag)
        tfLastName.rx.text.orEmpty.bind(to: fillNameViewModel.txtLastName).disposed(by: disposeBag)
    }
    
    func subscribeIsBtnContinue() {
        fillNameViewModel.isBtnContinureEnable.subscribe(onNext: { enable in
            self.btnNext.isEnabled = enable
            self.btnNext.backgroundColor = enable ? .blue : UIColor.blue.withAlphaComponent(0.3)
            
        })
        .disposed(by: disposeBag)
        
        btnNext.rx.tap.subscribe(onNext: { [weak self] in
            
            guard let self = self else{return}
            
            self.fillNameViewModel.saveFullName()
            
            self.fillNameViewModel.addUserRegister(VCC: self)
            
        })
        .disposed(by: disposeBag)
    }
    
    func subscribeToLoading() {
        fillNameViewModel.loadingBehavior.subscribe(onNext: { isLoading in
            if isLoading {
                self.showIndicator(withTitle: "", and: "")
            }else{
                self.hideIndicator()
            }
            
        })
        .disposed(by: disposeBag)
    }

}
extension FillNameSignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfFirstName {
            tfLastName.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
