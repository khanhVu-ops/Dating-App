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
    var listEdit = [ModelSetUpTBV]()
    var listEducation = [ModelSetUpTBV]()
    var listImg = [String]()

    func updateUI() {
        let text = userActive.firstName + " " + userActive.lastName
        lbName?.text = text
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
                     ModelSetUpTBV(title: "Marital Status", tfText: "\(userActive.material_status)", imgStr: "marital_status"),
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
        listImg.removeAll()
        for item in userActive.listImage {
            listImg.append(item)
        }
    }
    
    
    
    
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
