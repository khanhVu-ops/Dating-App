//
//  FillNameSignUpViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/23/22.
//

import UIKit

class FillNameSignUpViewController: BaseViewController {

    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:))))
        setUpView()
        
        // Do any additional setup after loading the view.
    }
    
    override func setUpView() {
        tfFirstName.delegate = self
        tfLastName.delegate = self
        btnNext.layer.cornerRadius = 25
        updateButtonUI(btnNext, enable: false, color: .blue)
        
    }
//    func updateUIBtn(enable: Bool) {
//        btnNext.isEnabled = enable
//        btnNext.alpha = enable ? 1 : 0.3
//    }
    

    @IBAction func didTapBtnNext(_ sender: Any) {
        guard let firstName = tfFirstName.text, let lastName = tfLastName.text else {
            return
        }
        GobalData.userRegister.firstName = firstName
        GobalData.userRegister.lastName = lastName
        print("GOBAL: \(GobalData.userRegister.phoneNumber)")
        DatabaseManager.shared.addUser(userActive: 1, phoneNumber: GobalData.userRegister.phoneNumber, gender: GobalData.userRegister.gender, firstName: GobalData.userRegister.firstName, lastName: GobalData.userRegister.lastName)
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "CustomTabbarController") as! CustomTabbarController
        self.navigationController?.pushViewController(vc, animated: true)
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        if tfFirstName.text?.isEmpty == false, tfLastName.text?.isEmpty == false {
            updateButtonUI(btnNext, enable: true, color: .blue)        }
    }
    
}
