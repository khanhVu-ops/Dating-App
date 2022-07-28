//
//  ProfileViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/27/22.
//

import UIKit
import FBSDKLoginKit
import RxSwift
import RxCocoa
import FirebaseAuth

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
    @IBOutlet weak var vAboutMe: UIView!
    @IBOutlet weak var vFvrFood: UIView!
    @IBOutlet weak var txtAboutMe: UITextView!
    @IBOutlet weak var txtFvrFood: UITextView!
    @IBOutlet weak var heightTxtAboutMe: NSLayoutConstraint!
    @IBOutlet weak var heightTxtFvrFood: NSLayoutConstraint!
    @IBOutlet weak var heightCltvListImage: NSLayoutConstraint!
    @IBOutlet weak var cltvListImage: UICollectionView!
    
    @IBOutlet weak var btnLogOut: UIButton!
    @IBOutlet weak var lbNoImage: UILabel!
    @IBOutlet weak var vBorderCltvImage: UIView!
    
    
    var imagePickerController = UIImagePickerController()
    let disposeBag = DisposeBag()
    let profileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("UID: \(String(describing: Auth.auth().currentUser?.uid))")

        setUpView()
        
        setUpUIListBasicInfo()
        subscribeToUpdateUI()
        subscribeToLoading()
        imagePickerController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        profileViewModel.fetchDataProfile()
        profileViewModel.updateUI()
//        profileViewModel.getListImg()
        profileViewModel.setUpTBV()
        DispatchQueue.main.async {
            self.cltvListImage.reloadData()
        }
    }
    
    override func setUpView() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:))))
        vTopCorner.layer.cornerRadius = vTopCorner.frame.width/3
        vBorderCltvImage.layer.cornerRadius = 20
        vBorderCltvImage.layer.borderWidth = 1
        vBorderCltvImage.layer.borderColor = UIColor.gray.cgColor
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
        
        profileViewModel.lbName = lbName
        profileViewModel.imgAvata = imgAvt
//        profileViewModel.updateAvata()
        btnLogOut.layer.cornerRadius = 20
        
        heightTxtAboutMe.isActive = false
        heightTxtFvrFood.isActive = false
        txtAboutMe.isScrollEnabled = false
        txtAboutMe.sizeToFit()
        txtFvrFood.isScrollEnabled = false
        txtFvrFood.sizeToFit()
        
        vAboutMe.layer.cornerRadius = 20
        vAboutMe.layer.masksToBounds = true
        vAboutMe.layer.borderWidth = 1
        vAboutMe.layer.borderColor = UIColor.gray.cgColor
        vFvrFood.layer.cornerRadius = 20
        vFvrFood.layer.masksToBounds = true
        vFvrFood.layer.borderWidth = 1
        vFvrFood.layer.borderColor = UIColor.gray.cgColor
        
        
        profileViewModel.txtAboutMe = txtAboutMe
        profileViewModel.txtFvrFood = txtFvrFood
        
        cltvListImage.dataSource = self
        cltvListImage.delegate = self
        cltvListImage.register(UINib(nibName: "EditProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EditProfileCollectionViewCell")
        tbvListEdit.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        tbvListEdit.backgroundColor = .clear
        tbvListEducation.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        tbvListEducation.backgroundColor = .clear
        cltvListImage.backgroundColor = .clear
    }
    
    func setUpUIListBasicInfo() {
        heightTbvConstraint.constant = CGFloat(6*120 + 60)
        heightTbvEducation.constant = CGFloat(2*120+60)
        
        profileViewModel.listEdit.bind(to: self.tbvListEdit.rx.items(cellIdentifier: "ProfileTableViewCell", cellType: ProfileTableViewCell.self)) { [weak self] row, item, cell in
            guard let item = self?.profileViewModel.listEdit.value[row] else {return}
            cell.configure(item: item)
            cell.btnEdit.isHidden = true
            cell.tfEnter.isUserInteractionEnabled = false
        }
        .disposed(by: disposeBag)
        
        profileViewModel.listEducation.bind(to: self.tbvListEducation.rx.items(cellIdentifier: "ProfileTableViewCell", cellType: ProfileTableViewCell.self)) { [weak self] row, item, cell in
            
            guard let item = self?.profileViewModel.listEducation.value[row] else {return}
            cell.configure(item: item)
            cell.btnEdit.isHidden = true
            cell.tfEnter.isUserInteractionEnabled = false
        }
        .disposed(by: disposeBag)
    }
    
    func subscribeToUpdateUI() {
        profileViewModel.userActiveRelay.subscribe(onNext: { [weak self] data in
            self?.profileViewModel.updateUI()
//            self?.profileViewModel.getListImg()
            self?.profileViewModel.setUpTBV()
            DispatchQueue.main.async {
                self?.cltvListImage.reloadData()
            }
        })
        .disposed(by: disposeBag)
    }
    
    func subscribeToLoading() {
        profileViewModel.loadingBehavior.subscribe(onNext: { isLoading in
            if isLoading {
                self.showIndicator(withTitle: "", and: "")
            }else{
                self.hideIndicator()
            }
            
        })
        .disposed(by: disposeBag)
    }
        
    @IBAction func didTapLogOut(_ sender: Any) {
//        let loginManager = LoginManager()
//        loginManager.logOut()
//        DatabaseManager.shared.logOutUser()
        
        DatabaseManager.auth.logOutUser { (bool) in
            if bool{
                let st = UIStoryboard(name: "Main", bundle: nil)
                let vc = st.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
                self.navigationController?.setViewControllers([vc], animated: true)
            }
        }
        
        
        
        
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

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 60)/3, height: (self.view.frame.width - 60)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
}
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = profileViewModel.userActiveRelay.value.listImages?.count else {return 0}
        if count == 0 {
            lbNoImage.isHidden = false
            return 0
            
        }
        lbNoImage.isHidden = true
        let height = profileViewModel.configureHeightCltvImage(view: self.view)
        heightCltvListImage.constant = CGFloat(height)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cltvListImage.dequeueReusableCell(withReuseIdentifier: "EditProfileCollectionViewCell", for: indexPath) as! EditProfileCollectionViewCell
        if let imgStr = self.profileViewModel.userActiveRelay.value.listImages?[indexPath.item] {
            cell.confifure(imgStr: imgStr)
        }
        return cell
    }
    
}
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        if picker.sourceType == .photoLibrary {
            let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            img?.upload(uid: uid, folder: "avata", completion: { (url) in
                DatabaseManager.auth.addAvataUser(url: url ) { (bool) in
                    if bool {
                        print("Save Image Succesfull")
                    }else {
                        print("NO")
                    }
                }
            })
            imgAvt.image = img
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
