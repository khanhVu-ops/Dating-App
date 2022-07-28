//
//  ManagerUserdefaults.swift
//  Habiibi
//
//  Created by KhanhVu on 7/27/22.
//

import Foundation
class ManagerUserdefaults {
    
    static let shared = ManagerUserdefaults()
    
    let userDefault = UserDefaults.standard
    
    
    func updateInfoCurrentUser(with user: UserModels) {
        setUserName(userName: user.userName ?? "")
        setUid(uid: user.uid ?? "")
        setAvataUrl(avataUrl: user.avata ?? "")
    }
    
    func setUserName(userName: String) {
        userDefault.setValue(userName, forKey: "userName")
    }
    
    func setUid(uid: String) {
        userDefault.setValue(uid, forKey: "uid")
    }
    
    func setAvataUrl(avataUrl: String) {
        userDefault.setValue(avataUrl, forKey: "avata")
    }
    
    func getUsername()-> String {
        guard let name = userDefault.string(forKey: "userName") else{
            return ""
            
        }
        return name
    }
    func getUid() -> String {
        
        guard let id = userDefault.string(forKey: "uid") else {
            return ""
            
        }
        return id
        
    }
    func getAvataUrl() -> String {
        guard let avata = userDefault.string(forKey: "avata") else {
            return ""
        }
        return avata
    }
}
