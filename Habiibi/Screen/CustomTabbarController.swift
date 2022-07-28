//
//  TabbarViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/27/22.
//

import UIKit
import FirebaseAuth
class CustomTabbarController: UITabBarController {
    
    var selectID = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = selectID
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        DatabaseManager.auth.fetchDataUser(uid: uid) { (user, error) in
            guard let user = user , error == nil else{
                return
            }
            ManagerUserdefaults.shared.updateInfoCurrentUser(with: user)
            
        }
        
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    
}
extension CustomTabbarController: UITabBarControllerDelegate {
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


