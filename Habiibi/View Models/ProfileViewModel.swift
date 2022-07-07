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
    var lbCountry: UILabel?
    let userActive = DatabaseManager.shared.fetchDataUser()
    var listItem = [UserModel]()
    let disposeBag = DisposeBag()
    var imgAvata: UIImageView?
    var tfEditFirstName: UITextField!
    var tfEditLastName: UITextField!
    var tfEditCountry: UITextField!
    var tbvImgEdit: UITableView!
    var listImg = [String]()
    
    func updateUI() {
        let text = userActive.firstName + " " + userActive.lastName
        lbName?.text = text
        lbCountry?.text = userActive.country
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
    
    
    
    func setUpTextInTextField() {
        for item in userActive.listImage {
            listImg.append(item)
        }
        tfEditFirstName.text = userActive.firstName
        tfEditLastName.text = userActive.lastName
        tfEditCountry.text = userActive.country
        DispatchQueue.main.async {
            self.tbvImgEdit.reloadData()
        }
        
    }
    
    func saveDataEdited() {
        let firstName = tfEditFirstName.text ?? ""
        let lastName = tfEditLastName.text ?? ""
        let country = tfEditCountry.text ?? ""
        let list = listImg
        
        DatabaseManager.shared.updateProfileEditing(firstName: firstName, lastName: lastName, country: country, listImg: list)
        
    }
    
//    func getNameEdited(textField: UITextField) {
//        let text = textField.text
//
//    }
//    func getCountryEdited(textField: UITextField) {
//
//    }
    
    
    
}
