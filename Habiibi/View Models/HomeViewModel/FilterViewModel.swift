//
//  FilterViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/11/22.
//

import Foundation
import UIKit

class FilterViewModel {
    var listAge = ["All ages", "From 0 to 14 years old", "From 15 to 18 years old", "From 19 to 22 years old", "From 23 to 26 years old", "From 27 to 30 years old", "Over 30 years old" ]
    
    let ages = [(0,100), (0,14), (15,18), (19,22), (23,26), (27,30), (30,100)]
    
    var from = 0
    var destination = 100
}

