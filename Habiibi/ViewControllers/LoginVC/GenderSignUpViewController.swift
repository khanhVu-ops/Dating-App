//
//  GenderSignUpViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/23/22.
//

import UIKit

class GenderSignUpViewController: BaseViewController {

    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    var didTapMale = false
    var didTapFemale = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
    }
    override func setUpView() {
        btnContinue.layer.cornerRadius = 25
        
        btnMale.layer.cornerRadius = 30
        btnFemale.layer.cornerRadius = 30
        
        btnMale.layer.borderWidth = 3
        btnMale.layer.borderColor = UIColor.gray.cgColor
        btnFemale.layer.borderWidth = 3
        btnFemale.layer.borderColor = UIColor.gray.cgColor
        
        btnMale.layer.shadowOffset = CGSize(width: 0.4, height: 0.4)
        btnMale.layer.shadowColor = UIColor.gray.cgColor
        btnMale.layer.shadowRadius = 3
        btnFemale.layer.shadowOffset = CGSize(width: 0.4, height: 0.4)
        btnFemale.layer.shadowColor = UIColor.gray.cgColor
        btnFemale.layer.shadowRadius = 3
        
        updateButtonUI(btnContinue, enable: false, color: .blue)
    }
    
//    func updateUI(enable: Bool) {
//        btnContinue.isEnabled = enable
//        btnContinue.alpha = enable ? 1 : 0.3
//
//    }
    
    
    @IBAction func didTapBtnMale(_ sender: Any) {
        
        if !didTapMale {
            UIView.animate(withDuration: 0.3) { [self] in
                self.btnMale.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.btnFemale.transform = .identity
                self.didTapMale = true
                self.didTapFemale = false
                updateButtonUI(btnContinue, enable: true, color: .blue)
            }
            
        }else {
            UIView.animate(withDuration: 0.3) { [self] in
                self.btnMale.transform = .identity
                self.didTapMale = false
                updateButtonUI(btnContinue, enable: false, color: .blue)
//                self.btnFemale.transform = CGAffineTransform(scaleX: 2, y: 2)
            }
            
        }
    }
    
    @IBAction func didTapBtnFemale(_ sender: Any) {
        
        if !didTapFemale {
            UIView.animate(withDuration: 0.3) { [self] in
                self.btnFemale.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.btnMale.transform = .identity
                self.didTapFemale = true
                self.didTapMale = false
                updateButtonUI(btnContinue, enable: true, color: .blue)
            }
            
        }else {
            UIView.animate(withDuration: 0.3) { [self] in
                self.btnFemale.transform = .identity
                self.didTapFemale = false
                updateButtonUI(btnContinue, enable: false, color: .blue)
                
//                self.btnMale.transform = CGAffineTransform(scaleX: 2, y: 2)
            }
            
        }
        
        
    }
   
    @IBAction func didTapBtnContinue(_ sender: Any) {
        
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "FillNameSignUpViewController") as! FillNameSignUpViewController
        
        if didTapMale {
            GobalData.userRegister.gender = "Male"
           
        }else if didTapFemale {
            GobalData.userRegister.gender = "Female"
            
        }
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
