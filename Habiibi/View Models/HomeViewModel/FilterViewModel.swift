//
//  FilterViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/11/22.
//

import Foundation
import UIKit

class FilterViewModel {
    var item = FilterModel(gender: "", fromAge: "0", destinationAge: "100")
    var tapFemale = false
    var tapMale = false
    var tfFrom: UITextField!
    var tfDestination: UITextField!
    
    func updateUIComponent() {
        if item.fromAge == "0" {
            tfFrom.text = ""
        }else {
            tfFrom.text = item.fromAge
        }
        if item.destinationAge == "0" || item.destinationAge == "100" {
            tfDestination.text = ""
        }else {
            tfDestination.text = item.destinationAge
        }
        if item.gender == "Male" {
            tapMale = true
        }
        if item.gender == "Female" {
            tapFemale = true
        }
    }
    
    func configureBtnColor(btn: UIView, enable: Bool) {
        btn.backgroundColor = enable ? .red : .white
    }
    
    func getGender()  {
        if tapMale {
            item.gender = "Male"
        }else if tapFemale {
            item.gender = "Female"
        }else {
            item.gender = ""
        }
    }
//    func getAge() {
//        
//    }
}

