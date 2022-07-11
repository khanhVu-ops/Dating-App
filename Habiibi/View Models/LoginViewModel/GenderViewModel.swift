//
//  GenderViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/11/22.
//

import Foundation
import UIKit

class GenderViewModel {
    var didTapMale = false
    var didTapFemale = false
    
    func saveDataToGobalData(){
        if didTapMale {
            GobalData.userRegister.gender = "Male"
           
        }else if didTapFemale {
            GobalData.userRegister.gender = "Female"
            
        }
    }
}
