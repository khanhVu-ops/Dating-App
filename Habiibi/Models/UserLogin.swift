////
////  UserLogin.swift
////  Habiibi
////
////  Created by KhanhVu on 6/23/22.
////
//
//import Foundation
//import RealmSwift
//
//final class UserLogin: Object {
//    @objc dynamic var userActive = 0
//    @objc dynamic var phoneNumber = ""
//    @objc dynamic var gender = ""
//    @objc dynamic var firstName = ""
//    @objc dynamic var lastName = ""
//    @objc dynamic var imgAvt = "img_avt_default"
//    @objc dynamic var country = ""
//    @objc dynamic var height = ""
//    @objc dynamic var children = ""
//    @objc dynamic var material_status = ""
//    @objc dynamic var smoker = ""
//    @objc dynamic var body_type = ""
//    @objc dynamic var education = ""
//    @objc dynamic var profession = ""
//    @objc dynamic var about_me = "Please enter in your information!!"
//    @objc dynamic var favorite_food = "Please enter your favorite food"
//    
//    let listLiked = List<Int>()
//    let listDisLiked = List<Int>()
//    let listImage = List<String>()
//    
//    override static func primaryKey() -> String? {
//        return "phoneNumber"
//    }
//}
//
//
