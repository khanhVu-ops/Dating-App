//
//  DataBaseManager.swift
//  Habiibi
//
//  Created by KhanhVu on 6/23/22.
//

import Foundation
import RealmSwift
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import FirebaseCore
//protocol DatabaseManagerProtocol {
//    func addUser(userActive: Int, phoneNumber: String, gender: String, firstName: String, lastName: String)
//    func loginUser(phoneNumber: String) ->Bool
//    func fetchDataUser() -> UserLogin
//    func logOutUser()
//    func checkUserActive() -> Bool
//    func addListUserInteraction(id: Int, like: Bool)
//    func addImgAvata(string: String)
//    func updateProfileEditing(property: String, text: String)
//    func updateListImage(list: [String])
//}

protocol DataBaseAuthProtocol {
    func registerAccount(completion: @escaping (Bool) -> Void)
    func checkAccountExists(uid: String, completion: @escaping (Bool) -> Void)
    func addAvataUser(url: URL?, completion: @escaping (Bool) -> Void)
    func fetchDataUser(uid: String, completion: @escaping (UserModels?, Error?) -> Void)
    func updateProfileEditing(property: String, text: String, completion: @escaping (Bool) -> Void)
    func updateListImage(list: [String], completion: @escaping (Bool) -> Void)
    func fetchDataListUsers(completion: @escaping ([UserModels]?, Error?) -> Void)
    func addUserInteraction(uid: String, username: String, avata: String, like: Bool)
    func fetchListChatAvailble(uid: String, completion: @escaping ([Chat]?,[DocumentReference]?, Error?) -> Void)
    func logOutUser(completion: @escaping (Bool) -> Void)
}

class DatabaseManager {
    //    static let shared: DatabaseManagerProtocol = RealmDatabaseManager()
    static let auth: DataBaseAuthProtocol = AuthFirebaseManager()
    
}

class AuthFirebaseManager: DataBaseAuthProtocol {
    
    
    let db = Firestore.firestore()
    //    let user = Auth.auth().currentUser
    
    
    func registerAccount(completion: @escaping (Bool) -> Void) {
        let user = Auth.auth().currentUser
        guard let userId = user?.uid else{return}
        
        let newUser = [
            "phoneNumber" : GobalData.phoneNumber,
            "userName" : "\(GobalData.firstName) \(GobalData.lastName)",
            "age": "",
            "gender": GobalData.gender,
            "country": "",
            "descripInfo": "",
            "favoritFood": "",
            "height": "",
            "children": "",
            "matrial_status": "",
            "smoker": "",
            "bodyType": "",
            "education": "",
            "profession": "",
            "avata": "",
            "listImages": [],
        ] as [String : Any]
        
        db.collection("users").document(userId).setData(newUser)
        { err in
            if let err = err {
                completion(false)
                print("Error writing document: \(err)")
            } else {
                completion(true)
                print("Document successfully written!")
            }
        }
        
        
        
        
    }
    
    func checkAccountExists(uid: String, completion: @escaping (Bool) -> Void) {
        //        guard let userId = user?.uid else{return}
        _ = Auth.auth().currentUser
        let usersRef = db.collection("users").document(uid)
        
        usersRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
                //                   print("Document does not exist")
            }
        }
        
    }
    func addAvataUser(url: URL?, completion: @escaping (Bool) -> Void) {
        let user = Auth.auth().currentUser
        guard let userId = user?.uid else{return}
        guard let urlStr = url else {return}
        let userRef = db.collection("users").document(userId)
        userRef.updateData([
            "avata": "\(urlStr)"
        ]) { err in
            if let err = err {
                completion(false)
                print("Error updating document: \(err)")
            } else {
                completion(true)
                print("Document successfully updated")
            }
        }
    }
    
    func fetchDataListUsers(completion: @escaping ([UserModels]?, Error?) -> Void) {
        let user = Auth.auth().currentUser
        guard let userId = user?.uid else{return}
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(nil,err)
                print("Error getting documents: \(err)")
            } else {
                var listDoc = querySnapshot!.documents
                
                listDoc = listDoc.filter() {$0.documentID != userId}
                
                var listUser = [UserModels]()
                for document in listDoc {
                    let item = UserModels(json: document.data())
                    listUser.append(item)
                }
                completion(listUser,nil)
            }
        }
    }
    
    func fetchDataUser(uid: String, completion: @escaping (UserModels?, Error?) -> Void){
//        let user = Auth.auth().currentUser
//        guard let uid = user?.uid else{return}
        
        db.collection("users").document(uid).getDocument { (document, error) in
            guard let document = document else {
                print("Error fetching document: \(error!)")
                completion(nil,error)
                return
            }
           
            
            let data = UserModels(json: document.data() ?? [:])
            
            completion(data,nil)
            print(" data: \(document.data() ?? [:])")
        }
        
        //
    }
    
    func updateListImage(list: [String], completion: @escaping (Bool) -> Void) {
        let user = Auth.auth().currentUser
        guard let userId = user?.uid else{return}
        //        guard let urlStr = url else {return}
        let userRef = db.collection("users").document(userId)
        userRef.updateData([
            "listImages": list
        ]) { err in
            if let err = err {
                completion(false)
                print("Error updating document: \(err)")
            } else {
                completion(true)
                print("Document successfully updated")
            }
        }
    }
    
    func updateProfileEditing(property: String, text: String, completion: @escaping (Bool) -> Void) {
        let user = Auth.auth().currentUser
        guard let userId = user?.uid else{return}
        //        guard let urlStr = url else {return}
        let userRef = db.collection("users").document(userId)
        userRef.updateData([
            "\(property)": text
        ]) { err in
            if let err = err {
                completion(false)
                print("Error updating document: \(err)")
            } else {
                completion(true)
                print("Document successfully updated")
            }
        }
    }
    
    func addUserInteraction(uid: String, username: String, avata: String, like: Bool) {
        let user = Auth.auth().currentUser
        guard let userId = user?.uid else{return}
        //        guard let urlStr = url else {return}
        
        let userRef = db.collection("users").document(userId)
        
        if like {
            let userLiked: [String:Any] = [
                "uid": uid,
                "userName": username,
                "avata": avata
            ]
            userRef.collection("threadLiked").document(uid).setData(userLiked) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
           
            
//            userRef.getDocument { (snapshot, error) in
//                guard let document = snapshot?.data(), error == nil else{
//                    return
//                }
////                var listLiked = [FriendModel]()
////                let userData = UserModels(json: document)
////                listLiked = userData.listUserLiked ?? []
//
////                if listLiked.filter({$0.uid == uid}).count == 0{
////                    listLiked.append(FriendModel(uid: uid, userName: username, avata: avata))
////                }
//
////                userRef.updateData([
////                    "listUserLiked": listLiked
////                ]) { err in
////                    if let err = err {
////                        print("Error updating document: \(err)")
////                    } else {
////                        print("Document successfully updated")
////                    }
////                }
//            }
//
        }else {
            userRef.updateData(["listUserDisLiked": FieldValue.arrayUnion([uid])])
        }

    }

    func fetchListChatAvailble(uid: String, completion: @escaping ([Chat]?, [DocumentReference]?, Error?) -> Void) {
        let db = Firestore.firestore().collection("Chats")
                .whereField("users", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
        
        
        db.getDocuments { (chatQuerySnap, error) in
            
            if let error = error {
                print("Error: \(error)")
                completion(nil,nil,error)
                return
            } else {
                
                //Count the no. of documents returned
                guard let queryCount = chatQuerySnap?.documents.count else {
                    completion(nil,nil,error)
                    return
                }
                
                if queryCount == 0 {
                    //If documents count is zero that means there is no chat available and we need to create a new instance
                   completion(nil,nil,nil)
                }
                else if queryCount >= 1 {
                    //Chat(s) found for currentUser
                    var listChats: [Chat] = []
                    var listDoc: [DocumentReference] = []
                    for doc in chatQuerySnap!.documents {
                        
                        let chat = Chat(dictionary: doc.data())
                        listChats.append(chat!)
                        listDoc.append(doc.reference)
                        //Get the chat which has user2 id
                    }
                    completion(listChats,listDoc,nil)
                } else {
                    completion(nil,nil,nil)
                    print("Let's hope this error never prints!")
                }
            }
        }
    }
    
    func logOutUser(completion: @escaping (Bool) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completion(true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(false)
        }
    }
    
}

//
//class RealmDatabaseManager: DatabaseManagerProtocol {
//
//    func fetchDataUser() -> UserLogin{
//        var users = [UserLogin]()
//        do {
//            // realm
//            let realm = try Realm()
//
//            // results
//            let results = realm.objects(UserLogin.self).filter("userActive = 1")
//
//            // convert to array
//            users = Array(results)
//
//            // call back
//            return users.first ?? UserLogin()
//
//        } catch {
//            // call back
//            print(error)
//        }
//        return UserLogin()
//    }
//
//    func checkUserActive() ->Bool {
//        var users = [UserLogin]()
//        do {
//            // realm
//            let realm = try Realm()
//
//            // results
//            let results = realm.objects(UserLogin.self)
//
//            // convert to array
//            users = Array(results)
//
//            for item in users {
//                if (item.userActive != 0) {
//                    return true
//                }
//            }
//            // call back
//
//        } catch {
//            // call back
//            print(error)
//        }
//        return false
//    }
//
//    func addUser(userActive: Int, phoneNumber: String, gender: String, firstName: String, lastName: String) {
//        let realm = try! Realm()
//
//        // tạo 1 book
//        let user = UserLogin()
//        user.userActive = userActive
//        user.phoneNumber = phoneNumber
//        user.gender = gender
//        user.firstName = firstName
//        user.lastName = lastName
//        //realm write
//        try! realm.write {
//            realm.add(user)
//        }
//    }
//    func loginUser(phoneNumber: String) -> Bool {
//        var users = [UserLogin]()
//        do {
//            // realm
//            let realm = try Realm()
//
//            // results
//            let results = realm.objects(UserLogin.self)
//
//            // convert to array
//            users = Array(results)
//
//            for item in users {
//                if item.phoneNumber == phoneNumber {
//                    try! realm.write {
//                        item.userActive = 1
//                    }
//                    return true
//                }
//            }
//            // call back
//
//
//        } catch {
//            // call back
//            print(error)
//        }
//        return false
//    }
//
//    func logOutUser() {
//        var users = [UserLogin]()
//        do {
//            // realm
//            let realm = try Realm()
//
//            // results
//            let results = realm.objects(UserLogin.self)
//
//            // convert to array
//            users = Array(results)
//
//            for item in users {
//
//                try! realm.write {
//                    item.userActive = 0
//                }
//
//
//            }
//            // call back
//
//        } catch {
//            // call back
//            print(error)
//        }
//    }
//
//    func addListUserInteraction(id: Int, like: Bool)  {
//        var users = [UserLogin]()
//        do {
//            // realm
//            let realm = try Realm()
//
//            // results
//            let results = realm.objects(UserLogin.self).filter("userActive = 1")
//
//            // convert to array
//            users = Array(results)
//            for item in users {
//
//                try! realm.write {
//                    if like {
//                        var bool = true
//                        for i in item.listLiked {
//                            if id == i {
//                                bool = false
//                            }
//                        }
//                        if bool {
//                            item.listLiked.append(id)
//                        }
//
//                    }else {
//                        var bool = true
//                        for i in item.listDisLiked {
//                            if id == i {
//                                bool = false
//                            }
//                        }
//                        if bool {
//                            item.listDisLiked.append(id)
//                        }
//
//                    }
//
//                }
//
//
//            }
//
//        } catch {
//            // call back
//            print(error)
//        }
//
//    }
//
//    func addImgAvata(string: String) {
//        var users = [UserLogin]()
//        do {
//            // realm
//            let realm = try Realm()
//
//            // results
//            let results = realm.objects(UserLogin.self).filter("userActive = 1")
//
//            // convert to array
//            users = Array(results)
//            for item in users {
//
//                try! realm.write {
//                    item.imgAvt = string
//
//                }
//
//
//            }
//
//        } catch {
//            // call back
//            print(error)
//        }
//    }
//    func updateProfileEditing(property: String, text: String) {
//        var users = [UserLogin]()
//        do {
//            // realm
//            let realm = try Realm()
//
//            // results
//            let results = realm.objects(UserLogin.self).filter("userActive = 1")
//
//            // convert to array
//            users = Array(results)
//            for item in users {
//
//                try! realm.write {
//                    switch property {
//                    case "country":
//                        item.country = text
//                    case "height":
//                        item.height = text
//                    case "children":
//                        item.children = text
//                    case "material_status":
//                        item.material_status = text
//                    case "smoker":
//                        item.smoker = text
//                    case "body_type":
//                        item.body_type = text
//                    case "education":
//                        item.education = text
//                    case "about_me":
//                        item.about_me = text
//                    case "favorite_food":
//                        item.favorite_food = text
//                    default:
//                        item.profession = text
//                    }
//
//
//                }
//            }
//
//        } catch {
//            // call back
//            print(error)
//        }
//    }
//
//    func updateListImage(list: [String]) {
//        var users = [UserLogin]()
//        do {
//            // realm
//            let realm = try Realm()
//
//            // results
//            let results = realm.objects(UserLogin.self).filter("userActive = 1")
//
//            // convert to array
//            users = Array(results)
//            for item in users {
//
//                try! realm.write {
//                    item.listImage.removeAll()
//                    for imgStr in list {
//                        item.listImage.append(imgStr)
//                    }
//
//                }
//
//
//            }
//
//        } catch {
//            // call back
//            print(error)
//        }
//    }
//}
//
