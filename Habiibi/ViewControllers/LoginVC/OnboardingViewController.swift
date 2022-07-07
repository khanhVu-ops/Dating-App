//
//  OnboardingViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/22/22.
//

import UIKit
import FBSDKLoginKit

class OnboardingViewController: BaseViewController {
    
    @IBOutlet weak var vBtnLoginFb: UIView!
    @IBOutlet weak var vLoginWithPhoneNumber: UIButton!
    
    var onboardingViewModel = OnboardingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        
    }
    override func setUpView() {
        
        if onboardingViewModel.checkAccountActive() {
            let st = UIStoryboard(name: "Main", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "CustomTabbarController") as! CustomTabbarController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:))))
        vBtnLoginFb.layer.cornerRadius = 25
        vBtnLoginFb.layer.masksToBounds = true
        vLoginWithPhoneNumber.layer.cornerRadius = 25
        vLoginWithPhoneNumber.layer.borderWidth = 0.8
        vLoginWithPhoneNumber.layer.borderColor = UIColor.black.cgColor
    }
    
   
    
    @IBAction func didTapBtnLoginPhoneNumber(_ sender: Any) {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapBtnLoginFb(_ sender: Any) {
        onboardingViewModel.loginWithFb(controller: self) { (bool) in
            if bool {
                let st = UIStoryboard(name: "Main", bundle: nil)
                let vc = st.instantiateViewController(withIdentifier: "CustomTabbarController") as! CustomTabbarController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}