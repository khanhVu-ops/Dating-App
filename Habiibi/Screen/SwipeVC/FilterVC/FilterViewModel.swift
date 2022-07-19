//
//  FilterViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/11/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FilterViewModel {
    var item = FilterModel(gender: "", fromAge: "0", destinationAge: "100")
    var tapFemale = false
    var tapMale = false
    var txtFrom = BehaviorRelay<String>(value: "")
    var txtDestination = BehaviorRelay<String>(value: "")
    
//    var isValidObserVable
    
    func updateUIComponent() {
        if item.fromAge == "0" {
            txtFrom.accept("")
        }else {
           txtFrom.accept(item.fromAge)
        }
        if item.destinationAge == "0" || item.destinationAge == "100" {
            txtDestination.accept("")
        }else {
            txtDestination.accept(item.destinationAge)
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
    
    func getItems()  {
        if tapMale {
            item.gender = "Male"
        }else if tapFemale {
            item.gender = "Female"
        }else {
            item.gender = ""
        }
        item.fromAge = txtFrom.value
        item.destinationAge = txtDestination.value
    }
}

