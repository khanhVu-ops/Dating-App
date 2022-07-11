//
//  CustomNavigationVC.swift
//  Habiibi
//
//  Created by KhanhVu on 7/11/22.
//

import UIKit
import FBSDKLoginKit

class CustomNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if checkAccountActive() {
            let st = UIStoryboard(name: "Main", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "CustomTabbarController") as! CustomTabbarController
//            self.pushViewController(vc, animated: true)
            self.setViewControllers([vc], animated: true)
            
        }else {
            let st = UIStoryboard(name: "Main", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
//            self.pushViewController(vc, animated: true)
            self.setViewControllers([vc], animated: true)
        }
        // Do any additional setup after loading the view.
    }
    
    func checkAccountActive() -> Bool{
        if DatabaseManager.shared.checkUserActive() {
            return true
        }
        
        if let token = AccessToken.current,
                 !token.isExpired {
            return true
        }
        
        return false
    }
    

}
