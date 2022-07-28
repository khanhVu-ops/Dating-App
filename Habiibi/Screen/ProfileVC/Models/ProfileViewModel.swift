//
//  ProfileViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/6/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseDatabase
import FirebaseAuth
class ProfileViewModel {
    
    var lbName: UILabel?
    let disposeBag = DisposeBag()
    var imgAvata: UIImageView?
    
    var listImg = [String]()
    var txtAboutMe: UITextView!
    var txtFvrFood: UITextView!
    var listItemWillSave = [ModelSetUpTBV]()
    
    var listEdit = BehaviorRelay<[ModelSetUpTBV]>(value: [])
    var listEducation = BehaviorRelay<[ModelSetUpTBV]>(value: [])
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var userActiveRelay = BehaviorRelay<UserModels>(value: UserModels())
    
    func fetchDataProfile() {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        DatabaseManager.auth.fetchDataUser(uid: uid) { [weak self] (data, error) in
            
            guard let data = data, error == nil else {return}
            self?.userActiveRelay.accept(data)
        
        }
    }
    
    func updateUI() {
        print("phone number : \(GobalData.phoneNumber)")
        let userActive = userActiveRelay.value
        let text = userActive.userName
        self.lbName?.text = text
        self.txtAboutMe.text = userActive.descripInfo
        self.txtFvrFood.text = userActive.favoriteFood
        //        lbCountry?.text = userActive.country
        if userActive.avata == "img_avt_default" {
            
            self.imgAvata?.image = UIImage(named: "img_avt_default")
        }else {
            guard  let avata = userActive.avata else {
                return
            }
            let url = URL(string: avata)
            self.imgAvata?.sd_setImage(with: url, placeholderImage: UIImage(named: "img_avt_default"))
            
        }
        
    }
    
    //    func updateAvata() {
    //        let imgStr = userActive.imgAvt
    //        imgAvata?.image = imgStr.toImage()
    //    }
    
    
    func setUpTBV() {
        let userActive = userActiveRelay.value
        listEdit.accept([ModelSetUpTBV(title: "Full name", tfText: "\(userActive.userName ?? "")", imgStr: "userName"),
                         ModelSetUpTBV(title: "Age", tfText: "\(userActive.age ?? "")", imgStr: "age"),
                         ModelSetUpTBV(title: "Country", tfText: "\(userActive.country ?? "")", imgStr: "country"),
                         ModelSetUpTBV(title: "Height", tfText: "\(userActive.height ?? "")", imgStr: "height"),
                         ModelSetUpTBV(title: "Children", tfText: "\(userActive.children ?? "")", imgStr: "children"),
                         ModelSetUpTBV(title: "Marital Status", tfText: "\(userActive.material_status ?? "")", imgStr: "material_status"),
                         ModelSetUpTBV(title: "Smoker", tfText: "\(userActive.smoker ?? "")", imgStr: "smoker"),
                         ModelSetUpTBV(title: "Body Type", tfText: "\(userActive.bodyType ?? "")", imgStr: "bodyType")
        ])
        
        listEducation.accept([ModelSetUpTBV(title: "Education", tfText: "\(userActive.education ?? "")", imgStr: "education"),
                              ModelSetUpTBV(title: "Profession", tfText: "\(userActive.profession ?? "")", imgStr: "profession")
        ])
        
        
    }
    
    func setUpCell(cell: ProfileTableViewCell, index: Int, list: [ModelSetUpTBV]) {
        cell.configure(item: list[index])
    }
    
    func getListImg() {
        let userActive = userActiveRelay.value
        guard let listImage = userActive.listImages else{return}
        if listImg.count == 0 {
            for item in listImage {
                listImg.append(item)
            }
        }
        
    }
    
    
    func presentOptionsPopovered(vc: BaseViewController ,btn: UIButton) {
        
        let st = UIStoryboard(name: "Main", bundle: nil)
        let popoverContent = st.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        //        popoverContent.delegate = self
        popoverContent.modalPresentationStyle = .popover
        if let popover = popoverContent.popoverPresentationController {
            //            popover.delegate = self
            let viewForSource = btn as UIView
            popover.sourceView = viewForSource
            
            popover.sourceRect = viewForSource.bounds
            popoverContent.preferredContentSize = CGSize(width: 200, height: 100)
            
        }
        vc.present(popoverContent, animated: true, completion: nil)
    }
    //
    func configureHeightCltvImage(view: UIView) -> Int {
        let userActive = userActiveRelay.value
        guard let listImage = userActive.listImages else{return 0}
        var res = 0
        let count = listImage.count
        
        let height = (view.frame.width - 60)/3
        let mul = count / 3
        if count % 3 == 0 {
            if mul == 1 {
                res = mul * Int(height) + 10
            }else {
                res = mul * Int(height) + 20
            }
        }else {
            if mul == 0 {
                res = (mul + 1) * Int(height) + 10
            }else {
                res = (mul + 1) * Int(height) + 20
            }
            
        }
        return res
    }
}
