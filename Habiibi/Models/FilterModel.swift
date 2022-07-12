//
//  FilterModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/12/22.
//

import Foundation
import UIKit

class FilterModel {
    var gender = ""
    var fromAge = ""
    var destinationAge = ""
    
    init(gender: String, fromAge: String, destinationAge: String) {
        self.gender = gender
        self.fromAge = fromAge
        self.destinationAge = destinationAge
    }
}
