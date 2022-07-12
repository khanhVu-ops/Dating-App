//
//  HomeModels.swift
//  Habiibi
//
//  Created by KhanhVu on 6/29/22.
//

import Foundation

class UserModel: NSObject, JsonInitObject {
    var id: Int?
    var name: String?
    var age: Int?
    var gender: String?
    var location: String?
    var descrip: String?
    var avata: String?
    var listImg: [String]?
    
    convenience init(id: Int?, name: String?, age: Int?, gender: String?, location: String?, descrip: String?, avata: String?, listImg: [String]?) {
        self.init()
        
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
        self.location = location
        self.descrip = descrip
        self.avata = avata
        self.listImg = listImg
    }
    required convenience init(json: [String : Any]) {
        self.init()
        for (key, value) in json {
            if key == "id", let wrapValue = value as? Int {
                let jsonValue = wrapValue
                self.id = jsonValue
            }
            if key == "name", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.name = jsonValue
            }
            if key == "age", let wrapValue = value as? Int {
                let jsonValue = wrapValue
                self.age = jsonValue
            }
            if key == "gender", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.gender = jsonValue
            }
            if key == "location", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.location = jsonValue
            }
            if key == "descrip", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.descrip = jsonValue
            }
            if key == "avata", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.avata = jsonValue
            }
            if key == "listImg", let wrapValue = value as? [String] {
                let jsonValue = wrapValue
                self.listImg = jsonValue
            }
        }
    }
    
    
}
