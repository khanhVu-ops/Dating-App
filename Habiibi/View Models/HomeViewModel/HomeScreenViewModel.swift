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

class HomeScreenViewModel {
    
    var controller: BaseViewController?
    let profileViewModel = ProfileViewModel()
    var vKoloda: KolodaView!
    var tbvImg: UITableView!
    var heightTbvConstraint: NSLayoutConstraint!
    let disposeBag = DisposeBag()
    let subject = BehaviorSubject<UserModel>(value: UserModel(id: 0, name: "___", age: 0, gender: "", location: "___", descrip: "___", avata: "lisa", listImg: ["",""]))
    let filterSubject = BehaviorSubject<FilterModel>(value: FilterModel(gender: "", fromAge: "", destinationAge: ""))
    var items = [UserModel]()
    var user: UserModel?
    var imgAvt = UIImageView()
    let userActive = DatabaseManager.shared.fetchDataUser()
    var filterItem = FilterModel(gender: "", fromAge: "", destinationAge: "")
    func getListUsers()  {
        
//        items.removeAll()
        APIService.requestListUsers { (data, error) in
            guard let data = data, error == nil else {
                return
            }
            self.items = data
            for id in self.userActive.listDisLiked {
//               / print("IDDDD: \(id)")
                self.items = self.items.filter() {$0.id != id}
            }
            
            DispatchQueue.main.async {
                self.vKoloda.reloadData()
                self.tbvImg.reloadData()
            }
            
        }
    }
    func setUpObservable() {
        
        subject.asObserver()
            .subscribe(onNext:{ [unowned self] user in
                let avt = user.avata ?? ""
//                print(user.descrip ?? "")
                
                imgAvt.image = UIImage(named: avt)
                DispatchQueue.main.async {
                    self.tbvImg.reloadData()
                }
                
                
            })
            .disposed(by: disposeBag)
    }
    
    func notifiObserver(data: UserModel) {
        self.subject.onNext(data)
    }
    
    func setUpObservableFilter() {
        filterSubject.asObserver()
            .subscribe(onNext: { [unowned self] value in
                self.filterItem = value
                APIService.requestListUsers { (data, error) in
                    guard let data = data, error == nil else {
                        return
                    }
                    self.items = data
                    for id in self.userActive.listDisLiked {
        //               / print("IDDDD: \(id)")
                        self.items = self.items.filter() {$0.id != id}
                    }
                    self.items = self.items.filter() {($0.age ?? 0) >= Int(value.fromAge) ?? 0 }
                    self.items = self.items.filter() {($0.age ?? 0) <= Int(value.destinationAge) ?? 100 }
                    if value.gender != "" {
                        self.items = self.items.filter() {$0.gender == value.gender}
                    }
                    
                    DispatchQueue.main.async {
                        self.vKoloda.reloadData()
                        self.tbvImg.reloadData()
                    }
                    
                }
               
            })
            .disposed(by: disposeBag)
    }
    func notifiObserverFilter(data: FilterModel) {
        self.filterSubject.onNext(data)
    }
}

