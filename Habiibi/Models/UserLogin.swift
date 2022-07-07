//
//  UserLogin.swift
//  Habiibi
//
//  Created by KhanhVu on 6/23/22.
//

import Foundation
import RealmSwift

final class UserLogin: Object {
    @objc dynamic var userActive = 0
    @objc dynamic var phoneNumber = ""
    @objc dynamic var gender = ""
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var imgAvt = "img_avt_default"
    @objc dynamic var country = "Country"
    let listLiked = List<Int>()
    let listDisLiked = List<Int>()
    let listImage = List<String>()
    
    override static func primaryKey() -> String? {
        return "phoneNumber"
    }
}


