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
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var btnEditing: UIButton!
    @IBOutlet weak var tbvListImage: UITableView!
    @IBOutlet weak var vAvata: UIView!
    @IBOutlet weak var heightTbvConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var scrView: UIScrollView!
    
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
        DispatchQueue.main.async {
            self.tbvListImage.reloadData()
        }
    }
    
    override func setUpView() {
        vAvata.layer.cornerRadius = vAvata.frame.height/2
        vAvata.layer.masksToBounds = true
        vAvata.layer.borderWidth = 4
        vAvata.layer.borderColor = UIColor.systemPink.cgColor
        btnEditing.layer.cornerRadius = btnEditing.frame.height/2
        tbvListImage.delegate = self
        tbvListImage.dataSource = self
        tbvListImage.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        tbvListImage.backgroundColor = .clear
        profileViewModel.lbName = lbName
        profileViewModel.lbCountry = lbCountry
        profileViewModel.imgAvata = imgAvt
        profileViewModel.updateAvata()
        
    }
    
    
    @IBAction func didTapLogOut(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        DatabaseManager.shared.logOutUser()
        let st = UIStoryboard(name: "Main", bundle: nil)
        _ = st.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapBtnEditAvata(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
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
        let count = profileViewModel.userActive.listImage.count
        heightTbvConstraint.constant = CGFloat(count*420)
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvListImage.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.configure(imgStr: profileViewModel.userActive.listImage[indexPath.row])
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
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
