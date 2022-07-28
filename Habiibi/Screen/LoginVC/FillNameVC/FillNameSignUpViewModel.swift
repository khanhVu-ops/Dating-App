//
//  FillNameSignUpViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/18/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FillNameSignUpViewModel {
    var txtFirstName = BehaviorRelay<String>(value: "")
    var txtLastName = BehaviorRelay<String>(value: "")
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var isValidFirstName: Observable<Bool> {
        return txtFirstName.map({ txt in
            return txt.count > 0
            
        })
    }
    var isValidLastName: Observable<Bool> {
        return txtLastName.map({ txt in
            return txt.count > 0
            
        })
    }
    
    var isBtnContinureEnable: Observable<Bool> {
        return Observable.combineLatest(isValidFirstName, isValidLastName) { (isFirstName, isLastName) in
            let isEnable = isFirstName && isLastName
            return isEnable
        }
    }
    
    func saveFullName() {
        GobalData.firstName = txtFirstName.value
        GobalData.lastName = txtLastName.value
    }
    
    func addUserRegister(VCC: BaseViewController) {
        loadingBehavior.accept(true)
        print("GOBAL: \(GobalData.phoneNumber)")
        DatabaseManager.auth.registerAccount { (bool) in
            if bool {
                let st = UIStoryboard(name: "Main", bundle: nil)
                let vc = st.instantiateViewController(withIdentifier: "CustomTabbarController") as! CustomTabbarController
                VCC.navigationController?.setViewControllers([vc], animated: true)
            }else {
                print("aaaa")
            }
        }
        loadingBehavior.accept(false)
    }
}
