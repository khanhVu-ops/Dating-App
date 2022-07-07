//
//  TabbarViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/27/22.
//

import UIKit

class CustomTabbarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = 1
        let userActive = DatabaseManager.shared.fetchDataUser()
        print("phone: \(userActive.phoneNumber)")
        print("phone: \(userActive.userActive)")
        print("gender: \(userActive.gender)")
        print("first: \(userActive.firstName)")
        print("disLike: \(userActive.listDisLiked.count)")
        print("disLike: \(userActive.listLiked.count)")
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


