//
//  ProfileViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/27/22.
//

import UIKit
import FBSDKLoginKit

class ProfileViewController: BaseViewController {
    @IBOutlet weak var imgAvt: UIImageView!
    @IBOutlet weak var lbName: UILabel!
//    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var btnEditing: UIButton!
    @IBOutlet weak var tbvListEdit: UITableView!
    @IBOutlet weak var tbvListEducation: UITableView!
    @IBOutlet weak var vAvata: UIView!
    @IBOutlet weak var heightTbvConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightTbvEducation: NSLayoutConstraint!
    @IBOutlet weak var vInfo: UIView!
    @IBOutlet weak var vEducation: UIView!
    
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var vTopCorner: Gradient!
    @IBOutlet weak var vBtnEdit: Gradient!
    
    @IBOutlet weak var btnLogOut: UIButton!
    var imagePickerController = UIImagePickerController()
    
    let profileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
//        profileViewModel.updateUI()
        imagePickerController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        profileViewModel.updateUI()
//        DispatchQueue.main.async {
//            self.tbvListImage.reloadData()
//        }
    }
    
    override func setUpView() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:))))
        vTopCorner.layer.cornerRadius = vTopCorner.frame.width/3
        vInfo.layer.cornerRadius = 20
        vInfo.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        vInfo.layer.shadowOpacity = 0.3
        vInfo.layer.shadowColor = UIColor.gray.cgColor
        vInfo.layer.shadowRadius = 10
        vEducation.layer.cornerRadius = 20
        vEducation.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        vEducation.layer.shadowOpacity = 0.3
        vEducation.layer.shadowColor = UIColor.gray.cgColor
        vEducation.layer.shadowRadius = 10
        
        imgAvt.layer.cornerRadius = imgAvt.frame.height/2
        vAvata.layer.cornerRadius = vAvata.frame.height/2
        vAvata.layer.masksToBounds = true
        
        vBtnEdit.layer.cornerRadius = vBtnEdit.frame.height/2
        vBtnEdit.layer.masksToBounds = true
        
        
        tbvListEdit.delegate = self
        tbvListEdit.dataSource = self
        tbvListEdit.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        tbvListEdit.backgroundColor = .clear
        tbvListEducation.delegate = self
        tbvListEducation.dataSource = self
        tbvListEducation.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        tbvListEducation.backgroundColor = .clear
        profileViewModel.lbName = lbName
        profileViewModel.imgAvata = imgAvt
        profileViewModel.updateAvata()
        btnLogOut.layer.cornerRadius = 20
    }
    
   
    
    @IBAction func didTapLogOut(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        DatabaseManager.shared.logOutUser()
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        self.navigationController?.setViewControllers([vc], animated: true)

//        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapBtnEditAvata(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
//        self.imagePickerController.sourceType = .camera
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func didTapBtnEditting(_ sender: Any) {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "EditingProfileViewController") as! EditingProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
}

extension ProfileViewController: UITableViewDelegate {

}
extension ProfileViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        heightTbvConstraint.constant = CGFloat(6*120 + 60)
        heightTbvEducation.constant = CGFloat(2*120+60)
        profileViewModel.setUpTBV()
        if tableView == tbvListEducation {
            return 2
        }else {
            return 6
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        if tableView == tbvListEdit {
            profileViewModel.setUpCell(cell: cell, index: indexPath.row, list: profileViewModel.listEdit)
        }else {
            profileViewModel.setUpCell(cell: cell, index: indexPath.row, list: profileViewModel.listEducation)
        }
        return cell
    }


}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .photoLibrary {
            let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            let imgStr = img?.toJpegString(compressionQuality: 0) ?? ""
            if imgStr.count > 0 {
                DatabaseManager.shared.addImgAvata(string: imgStr)
            }
//            pr/int("IMG: \(String(describing: imgStr))")
            imgAvt?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
//        else if picker.sourceType == .camera {
//            let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//            let imgStr = img?.toJpegString(compressionQuality: 0) ?? ""
//            if imgStr.count > 0 {
//                DatabaseManager.shared.addImgAvata(string: imgStr)
//            }
////            pr/int("IMG: \(String(describing: imgStr))")
//            imgAvt?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
