//
//  GenderViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/11/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class GenderViewModel {
    
    let didTapMale = BehaviorRelay<Bool>(value: false)
    let didTapFemale = BehaviorRelay<Bool>(value: false)
    
    var isBtnContinueEnable: Observable<Bool> {
        return Observable.combineLatest(didTapMale , didTapFemale) { ( tapMale, tapFemale) in
            let valid = tapMale || tapFemale
            return valid
        }
    }
    
    
    
    
    
    func saveDataToGobalData(){
        if didTapMale.value {
            GobalData.gender = "Male"

        }else if didTapFemale.value {
            GobalData.gender = "Female"

        }
    }
}
