//
//  DataBaseManager.swift
//  Habiibi
//
//  Created by KhanhVu on 6/23/22.
//

import Foundation
import RealmSwift

protocol DatabaseManagerProtocol {
    func addUser(userActive: Int, phoneNumber: String, gender: String, firstName: String, lastName: String)
    func loginUser(phoneNumber: String) ->Bool
    func fetchDataUser() -> UserLogin
    func logOutUser()
    func checkUserActive() -> Bool
    func addListUserInteraction(id: Int, like: Bool)
    func addImgAvata(string: String)
    func updateProfileEditing(property: String, text: String)
    func updateListImage(list: [String])
}

class DatabaseManager {
    static let shared: DatabaseManagerProtocol = RealmDatabaseManager()
    
}

class RealmDatabaseManager: DatabaseManagerProtocol {
    
    func fetchDataUser() -> UserLogin{
        var users = [UserLogin]()
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(UserLogin.self).filter("userActive = 1")
            
            // convert to array
            users = Array(results)
            
            // call back
            return users.first ?? UserLogin()
            
        } catch {
            // call back
            print(error)
        }
        return UserLogin()
    }
    
    func checkUserActive() ->Bool {
        var users = [UserLogin]()
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(UserLogin.self)
            
            // convert to array
            users = Array(results)
            
            for item in users {
                if (item.userActive != 0) {
                    return true
                }
            }
            // call back
            
        } catch {
            // call back
            print(error)
        }
        return false
    }
    
    func addUser(userActive: Int, phoneNumber: String, gender: String, firstName: String, lastName: String) {
        let realm = try! Realm()
        
        // tạo 1 book
        let user = UserLogin()
        user.userActive = userActive
        user.phoneNumber = phoneNumber
        user.gender = gender
        user.firstName = firstName
        user.lastName = lastName
        //realm write
        try! realm.write {
            realm.add(user)
        }
    }
    func loginUser(phoneNumber: String) -> Bool {
        var users = [UserLogin]()
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(UserLogin.self)
            
            // convert to array
            users = Array(results)
            
            for item in users {
                if item.phoneNumber == phoneNumber {
                    try! realm.write {
                        item.userActive = 1
                    }
                    return true
                }
            }
            // call back
           
            
        } catch {
            // call back
            print(error)
        }
        return false
    }
    
    func logOutUser() {
        var users = [UserLogin]()
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(UserLogin.self)
            
            // convert to array
            users = Array(results)
            
            for item in users {
                
                try! realm.write {
                    item.userActive = 0
                }
                  
                
            }
            // call back
            
        } catch {
            // call back
            print(error)
        }
    }
    
    func addListUserInteraction(id: Int, like: Bool)  {
        var users = [UserLogin]()
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(UserLogin.self).filter("userActive = 1")
            
            // convert to array
            users = Array(results)
            for item in users {
                
                try! realm.write {
                    if like {
                        var bool = true
                        for i in item.listLiked {
                            if id == i {
                                bool = false
                            }
                        }
                        if bool {
                            item.listLiked.append(id)
                        }
                        
                    }else {
                        var bool = true
                        for i in item.listDisLiked {
                            if id == i {
                                bool = false
                            }
                        }
                        if bool {
                            item.listDisLiked.append(id)
                        }
                        
                    }
                    
                }
                  
                
            }
            
        } catch {
            // call back
            print(error)
        }
        
    }
   
    func addImgAvata(string: String) {
        var users = [UserLogin]()
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(UserLogin.self).filter("userActive = 1")
            
            // convert to array
            users = Array(results)
            for item in users {
                
                try! realm.write {
                    item.imgAvt = string
                    
                }
                  
                
            }
            
        } catch {
            // call back
            print(error)
        }
    }
    func updateProfileEditing(property: String, text: String) {
        var users = [UserLogin]()
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(UserLogin.self).filter("userActive = 1")
            
            // convert to array
            users = Array(results)
            for item in users {
                
                try! realm.write {
                    switch property {
                    case "country":
                        item.country = text
                    case "height":
                        item.height = text
                    case "children":
                        item.children = text
                    case "material_status":
                        item.material_status = text
                    case "smoker":
                        item.smoker = text
                    case "body_type":
                        item.body_type = text
                    case "education":
                        item.education = text
                    case "about_me":
                        item.about_me = text
                    case "favorite_food":
                        item.favorite_food = text
                    default:
                        item.profession = text
                    }
                
                    
                }
            }
            
        } catch {
            // call back
            print(error)
        }
    }
    
    func updateListImage(list: [String]) {
        var users = [UserLogin]()
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(UserLogin.self).filter("userActive = 1")
            
            // convert to array
            users = Array(results)
            for item in users {
                
                try! realm.write {
                    item.listImage.removeAll()
                    for imgStr in list {
                        item.listImage.append(imgStr)
                    }
                    
                }
                  
                
            }
            
        } catch {
            // call back
            print(error)
        }
    }
}

