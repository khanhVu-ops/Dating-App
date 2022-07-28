//
//  MessageViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/27/22.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
class MessageViewModel {
    var listFriendBehavior = BehaviorRelay<[FriendModel]>(value: [])
    var listChatBehavior = BehaviorRelay<[Chat]>(value: [])
    
    var listDocument: [DocumentReference] = []
    
    var listResSearch = BehaviorRelay<[FriendModel]>(value: [])
    
//    var listItemFriendBehavior = BehaviorRelay<Message>(value: Message())
    let uid = Auth.auth().currentUser?.uid
    func getListFriend() {
        let db = Firestore.firestore()
        db.collection("users").document(uid ?? "").collection("threadLiked").getDocuments { [weak self] (snapshot, error) in
            guard let snapshot = snapshot, error == nil else{
                return
            }
            var listFriends = [FriendModel]()
            for doc in snapshot.documents {
                let data = doc.data()
                let friend = FriendModel(json: data)
                listFriends.append(friend)
            }
            self?.listFriendBehavior.accept(listFriends)
        }
    }
    
    func getListChat() {
        DatabaseManager.auth.fetchListChatAvailble(uid: uid ?? "") { (data, listdoc, error) in
            guard let data = data, let listDoc = listdoc, error == nil else {return}
            
            let listChats = data
            self.listDocument = listDoc
            self.listChatBehavior.accept(listChats)
        }
    }
}
