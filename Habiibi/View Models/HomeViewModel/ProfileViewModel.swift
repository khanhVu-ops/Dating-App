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

class ProfileViewModel {
    
    var lbName: UILabel?
//    var lbCountry: UILabel?
    let userActive = DatabaseManager.shared.fetchDataUser()
    var listItem = [UserModel]()
    let disposeBag = DisposeBag()
    var imgAvata: UIImageView?
    var tfEditFirstName: UITextField!
    var tfEditLastName: UITextField!
    var tfEditCountry: UITextField!
    var tbvListEdit: UITableView!
    var tbvListEducation: UITableView!
    var btnSave: UIButton!
    var listEdit = [ModelSetUpTBV]()
    var listEducation = [ModelSetUpTBV]()
    var listImg = [String]()
    var txtAboutMe: UITextView!
    var txtFvrFood: UITextView!
    var listItemWillSave = [ModelSetUpTBV]()
//    let subject = BehaviorSubject<Bool>(value: true)
    func updateUI() {
        let text = userActive.firstName + " " + userActive.lastName
        lbName?.text = text
        txtAboutMe.text = userActive.about_me
        txtFvrFood.text = userActive.favorite_food
//        lbCountry?.text = userActive.country
        if userActive.imgAvt == "img_avt_default" {
            imgAvata?.image = UIImage(named: "img_avt_default")
        }else {
            imgAvata?.image = userActive.imgAvt.toImage()
        }
    }
    
    func updateAvata() {
        let imgStr = userActive.imgAvt
        imgAvata?.image = imgStr.toImage()
    }
    
    
    func setUpTBV() {
        listEdit = [ModelSetUpTBV(title: "Country", tfText: userActive.country, imgStr: "country"),
                     ModelSetUpTBV(title: "Height", tfText: "\(userActive.height)", imgStr: "height"),
                     ModelSetUpTBV(title: "Children", tfText: "\(userActive.children)", imgStr: "children"),
                     ModelSetUpTBV(title: "Marital Status", tfText: "\(userActive.material_status)", imgStr: "material_status"),
                     ModelSetUpTBV(title: "Smoker", tfText: userActive.smoker, imgStr: "smoker"),
                     ModelSetUpTBV(title: "Body Type", tfText: userActive.body_type, imgStr: "body_type")
        ]
        
        listEducation = [ModelSetUpTBV(title: "Education", tfText: userActive.education, imgStr: "education"),
                         ModelSetUpTBV(title: "Profession", tfText: userActive.profession, imgStr: "profession")
        ]
        

    }
    
    func setUpCell(cell: ProfileTableViewCell, index: Int, list: [ModelSetUpTBV]) {
        cell.configure(item: list[index])
    }
    
    func getListImg() {
        if listImg.count == 0 {
            for item in userActive.listImage {
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
//    func setUpObservable() {
//        subject.asObserver()
//            .subscribe(onNext:{ [unowned self] value in
//                btnSave.isEnabled = value
//                btnSave.backgroundColor = value ? .gray : .gray.withAlphaComponent(0.3)
//
//            })
//            .disposed(by: disposeBag)
//    }
    
    
    
    
//    func saveDataEdited() {
//        let firstName = tfEditFirstName.text ?? ""
//        let lastName = tfEditLastName.text ?? ""
//        let country = tfEditCountry.text ?? ""
//        let list = listImg
//
//        DatabaseManager.shared.updateProfileEditing(firstName: firstName, lastName: lastName, country: country, listImg: list)
//
//    }
    
//    func getNameEdited(textField: UITextField) {
//        let text = textField.text
//
//    }
//    func getCountryEdited(textField: UITextField) {
//
//    }
    
    
    
}
