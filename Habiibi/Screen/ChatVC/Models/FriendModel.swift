//
//  FriendModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/27/22.
//

import Foundation

class FriendModel {
    var uid: String?
    var userName: String?
    var avata: String?
    
    convenience init(uid: String?,
                     userName: String?,
                     avata: String?) {
        self.init()
        self.uid = uid
        self.userName = userName
        self.avata = avata
    }
    
    convenience init(json: [String : Any]) {
        self.init()
        
        for (key, value) in json {
            if key == "uid", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.uid = jsonValue
            }
            if key == "userName", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.userName = jsonValue
            }
            if key == "avata", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.avata = jsonValue
            }
        }
    }
}
