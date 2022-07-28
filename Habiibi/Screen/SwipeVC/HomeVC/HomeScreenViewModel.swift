//
//  HomeScreenViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 6/28/22.
//

import Foundation
import Koloda
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
class HomeScreenViewModel {
    
    var txtName = BehaviorRelay<String>(value: "")
    var txtDescrip = BehaviorRelay<String>(value: "")
    var heightTbvConstraint: NSLayoutConstraint!
    let disposeBag = DisposeBag()
    var vKoloda: KolodaView!
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    var listItemsBehavior = BehaviorRelay<[UserModels]>(value: [])
    var listImagesBehavior = BehaviorRelay<[String]>(value: [])
    let filterRelay = BehaviorRelay<FilterModel>(value: FilterModel(gender: "", fromAge: "", destinationAge: ""))
    var countTymBehavior = BehaviorRelay<Int>(value: 0)
    
    var uidUserDidShow = ""
    var nameUserDidShow = ""
    var avataUrlDidShow = ""
    func getListUsers() {
        
        loadingBehavior.accept(true)
        DatabaseManager.auth.fetchDataListUsers { [weak self] (data, error) in
            
            guard let self = self else{return}
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            self.loadingBehavior.accept(false)
            
            var items = data
            var listDisLiked = [String]()
            guard let uid = Auth.auth().currentUser?.uid else{return}
            DatabaseManager.auth.fetchDataUser(uid: uid) { (dataUser, error) in
                guard let dataUser = dataUser, error == nil else {
                    return
                    
                }
                
                listDisLiked = dataUser.listUserDisLiked ?? []
                
                
                for uid in listDisLiked {
    //               / print("IDDDD: \(id)")
                    items = items.filter() {$0.uid != uid}
                }
                let filterValue = self.filterRelay.value
                items = items.filter() {Int($0.age ?? "0") ?? 0 >= Int(filterValue.fromAge) ?? 0 }
                items = items.filter() {Int($0.age ?? "0") ?? 0 <= Int(filterValue.destinationAge) ?? 100 }
                if filterValue.gender != "" {
                    items = items.filter() {$0.gender == filterValue.gender}
                }
                
                if items.count > 0 {
                    self.listItemsBehavior.accept(items)
                    
                    
                }else {
                    self.listImagesBehavior.accept([])
                    self.listItemsBehavior.accept([])
                    self.txtDescrip.accept("")
                    self.txtName.accept("^__^")
                }
                
                DispatchQueue.main.async {
                    self.vKoloda.reloadData()
                    self.vKoloda.resetCurrentCardIndex()
                }
                
                
            }
            
            
        }
        
        
       
    }
    
    
    func emittedListimage(index: Int) {
        guard let listImg = listItemsBehavior.value[index].listImages else {return}
        listImagesBehavior.accept(listImg)
        heightTbvConstraint.constant = CGFloat(listImg.count*540)
        let item = listItemsBehavior.value[index]
        txtName.accept("\(item.userName ?? ""), \(item.age ?? "0"), from \(item.descripInfo ?? "")")
        txtDescrip.accept(item.descripInfo ?? "")
    }
    
    func setUserDidShow(index: Int) {
        guard let uidUser = listItemsBehavior.value[index].uid else {return}
        guard let nameUser = listItemsBehavior.value[index].userName else {return}
        guard let avataUser = listItemsBehavior.value[index].avata else {return}
        uidUserDidShow = uidUser
        nameUserDidShow = nameUser
        avataUrlDidShow = avataUser
    }
    
    func getUidUserDidShow() -> String {
        return uidUserDidShow
    }
    func getNameUserDidShow() -> String {
        return nameUserDidShow
    }
    func getAvataUrlUserDidShow() -> String {
        return avataUrlDidShow
    }
    
    func getListUserTym() {
        let db = Firestore.firestore()
        let uid = ManagerUserdefaults.shared.getUid()
        db.collection("users").getDocuments { [weak self] (document, error) in
            guard let document = document, error == nil else {
                return
            }
            self?.countTymBehavior.accept(0)
            for doc in document.documents {
                doc.reference.collection("threadLiked").document(uid).addSnapshotListener({ [weak self] (docSnapshot, error) in
                    if let docSnapshot = docSnapshot, docSnapshot.exists {
                        let val = self?.countTymBehavior.value ?? 0
                        let newVal = val + 1
                        self?.countTymBehavior.accept(newVal)
                    }
                })
            }
        }
    }
    
    
    
}

