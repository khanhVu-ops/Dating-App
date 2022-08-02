//
//  UserModels.swift
//  Habiibi
//
//  Created by KhanhVu on 7/22/22.
//

import Foundation

class UserModels {
    
    var uid : String?
    var account : String?
    var userName : String?
    var age : String?
    var gender : String?
    var country : String?
    var descripInfo : String?
    var favoriteFood : String?
    var height : String?
    var children : String?
    var material_status : String?
    var smoker : String?
    var bodyType : String?
    var education : String?
    var profession : String?
    var avata : String?
    var listImages : [String]?
    var listUserDisLiked : [String]?
    var listUserLiked : [FriendModel]?
    convenience init(uid : String?,
                     account : String?,
                     userName : String?,
                     age : String?,
                     gender : String?,
                     country : String?,
                     descripInfo : String?,
                     favoriteFood : String?,
                     height : String?,
                     children : String?,
                     material_status : String?,
                     smoker : String?,
                     bodyType : String?,
                     education : String?,
                     profession : String?,
                     avata : String?,
                     listImages: [String]?,
                     listUserDisLiked : [String]?,
                     listUserLiked : [FriendModel]?
    ) {
        self.init()
        self.uid = uid
        self.account = account
        self.userName = userName
        self.age = age
        self.gender = gender
        self.country = country
        self.descripInfo = descripInfo
        self.favoriteFood = favoriteFood
        self.height = height
        self.children = children
        self.material_status = material_status
        self.smoker = smoker
        self.bodyType = bodyType
        self.education = education
        self.profession = profession
        self.avata = avata
        self.listImages = listImages
        self.listUserDisLiked = listUserDisLiked
        self.listUserLiked = listUserLiked
    }
    
    convenience init(json: [String : Any]) {
        self.init()
        
        for (key, value) in json {
            if key == "uid", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.uid = jsonValue
            }
            if key == "account", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.account = jsonValue
            }
            if key == "userName", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.userName = jsonValue
            }
            if key == "age", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.age = jsonValue
            }
            if key == "gender", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.gender = jsonValue
            }
            if key == "country", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.country = jsonValue
            }
            if key == "descripInfo", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.descripInfo = jsonValue
            }
            if key == "favoriteFood", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.favoriteFood = jsonValue
            }
            if key == "height", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.height = jsonValue
            }
            if key == "children", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.children = jsonValue
            }
            if key == "material_status", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.material_status = jsonValue
            }
            if key == "smoker", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.smoker = jsonValue
            }
            if key == "bodyType", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.bodyType = jsonValue
            }
            if key == "education", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.education = jsonValue
            }
            if key == "profession", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.profession = jsonValue
            }
            if key == "avata", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.avata = jsonValue
            }
            if key == "listImages", let wrapValue = value as? [String] {
                let jsonValue = wrapValue
                self.listImages = jsonValue
            }
            if key == "listUserDisLiked", let wrapValue = value as? [String] {
                let jsonValue = wrapValue
                self.listUserDisLiked = jsonValue
            }
            if key == "listUserLiked", let wrapValue = value as? [[String : Any]] {
                let jsonValue = wrapValue.map({FriendModel(json: $0)})
                self.listUserLiked = jsonValue
            }
        }
    }
}
