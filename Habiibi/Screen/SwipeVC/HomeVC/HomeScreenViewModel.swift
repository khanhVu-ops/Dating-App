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
    
    var txtName = BehaviorRelay<String>(value: "")
    var txtDescrip = BehaviorRelay<String>(value: "")
    var heightTbvConstraint: NSLayoutConstraint!
    let disposeBag = DisposeBag()
    var vKoloda: KolodaView!
    let userActive = DatabaseManager.shared.fetchDataUser()
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    var listItemsBehavior = BehaviorRelay<[UserModel]>(value: [])
    var listImagesBehavior = BehaviorRelay<[String]>(value: [])
    let filterRelay = BehaviorRelay<FilterModel>(value: FilterModel(gender: "", fromAge: "", destinationAge: ""))
 
    func getListUsers()  {
        
        loadingBehavior.accept(true)
        
        APIService.requestListUsers { [unowned self] (data, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            self.loadingBehavior.accept(false)
            
            var items = data
            for id in self.userActive.listDisLiked {
//               / print("IDDDD: \(id)")
                items = items.filter() {$0.id != id}
            }
            let filterValue = filterRelay.value
            items = items.filter() {($0.age ?? 0) >= Int(filterValue.fromAge) ?? 0 }
            items = items.filter() {($0.age ?? 0) <= Int(filterValue.destinationAge) ?? 100 }
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
    
    
    func emittedListimage(index: Int) {
        guard let listImg = listItemsBehavior.value[index].listImg else {return}
        listImagesBehavior.accept(listImg)
        heightTbvConstraint.constant = CGFloat(listImg.count*540)
        let item = listItemsBehavior.value[index]
        txtName.accept("\(item.name ?? ""), \(item.age ?? 0), from \(item.descrip ?? "")")
        txtDescrip.accept(item.descrip ?? "")
    }
    
}

