//
//  ChatViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/27/22.
//

import Foundation
import Firebase
import MessageKit
import FirebaseFirestore
import SDWebImage
import RxSwift
import RxCocoa

class ChatViewModel {
    
    var currentUser = ManagerUserdefaults.shared
    
    var user2Name = ""
    var user2ImgUrl = ""
    var user2UID = ""
    private var docReference: DocumentReference?
    
    var messages = BehaviorRelay<[Message]>(value: [])
    
    
    func createNewChat() {
        let users = [self.currentUser.getUid(), self.user2UID]
        let data: [String: Any] = [
            "users":users
        ]
        
        let db = Firestore.firestore().collection("Chats")
        db.addDocument(data: data) { (error) in
            if let error = error {
                print("Unable to create chat! \(error)")
                return
            } else {
                self.loadChat()
            }
        }
    }
    
    func loadChat() {
        
        //Fetch all the chats which has current user in it
        let db = Firestore.firestore().collection("Chats")
            .whereField("users", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
        
        
        db.getDocuments { (chatQuerySnap, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                
                //Count the no. of documents returned
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }
                
                if queryCount == 0 {
                    //If documents count is zero that means there is no chat available and we need to create a new instance
                    self.createNewChat()
                }
                else if queryCount >= 1 {
                    //Chat(s) found for currentUser
                    for doc in chatQuerySnap!.documents {
                        
                        let chat = Chat(dictionary: doc.data())
                        //Get the chat which has user2 id
                        if (chat?.users.contains(self.user2UID))! {
                            
                            self.docReference = doc.reference
                            //fetch it's thread collection
                            doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                                    if let error = error {
                                        print("Error: \(error)")
                                        return
                                    } else {
                                        //                                self.messages.removeAll()
                                        var listMsg = [Message]()
                                        for message in threadQuery!.documents {
                                            
                                            let msg = Message(dictionary: message.data())
                                            listMsg.append(msg!)
                                            print("Data: \(msg?.content ?? "No message found")")
                                        }
                                        self.messages.accept(listMsg)
                                                                    
                                    }
                                })
                            return
                        } //end of if
                    } //end of for
                    self.createNewChat()
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
    }
    
    func insertNewMessage(_ message: Message) {
        
        var value = messages.value
        value.append(message)
        messages.accept(value)
    }
    func save(_ message: Message) {
        
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
        
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            
//            
            
        })
    }
    
}
