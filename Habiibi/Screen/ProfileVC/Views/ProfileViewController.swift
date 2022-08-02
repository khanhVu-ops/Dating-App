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

class ProfileViewController: BaseViewController, UIScrollViewDelegate {
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
        subscribeListImageCltv()
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
        
        //        cltvListImage.dataSource = self
        //        cltvListImage.delegate = self
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
    
    func subscribeListImageCltv() {
        profileViewModel.listImageBehavior.bind(to: cltvListImage.rx.items(cellIdentifier: "EditProfileCollectionViewCell", cellType: EditProfileCollectionViewCell.self)) {  row, item, cell in
            
            cell.confifure(imgStr: item)
            
        }.disposed(by: disposeBag)
        
        cltvListImage.rx.setDelegate(self).disposed(by: disposeBag)
        
        profileViewModel.listImageBehavior.subscribe(onNext: { [weak self] listItems in
            let height = self?.profileViewModel.configureHeightCltvImage(view: self?.view ?? UIView())
            self?.heightCltvListImage.constant = CGFloat(height ?? 0)
            if listItems.count == 0 {
                self?.lbNoImage.isHidden = false
            }else {
                self?.lbNoImage.isHidden = true
            }
            
        }).disposed(by: disposeBag)
        
        
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
        DatabaseManager.auth.logOutUser { (bool) in
            if bool{
                let st = UIStoryboard(name: "Main", bundle: nil)
                let vc = st.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
                self.navigationController?.setViewControllers([vc], animated: true)
            }
        }
        
    }
    
    @IBAction func didTapBtnEditAvata(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Choose your source", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default) {[weak self] (result : UIAlertAction) -> Void in
            print("Camera selected")
            self?.imagePickerController.sourceType = .camera
            self?.present((self?.imagePickerController)!, animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Photo library", style: .default) {[weak self] (result : UIAlertAction) -> Void in
            print("Photo selected")
            self?.imagePickerController.sourceType = .photoLibrary
            self?.present((self?.imagePickerController)!, animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (result) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func didTapBtnEditting(_ sender: Any) {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "EditingProfileViewController") as! EditingProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 60)/3, height: (self.view.frame.width - 60)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        profileViewModel.loadingBehavior.accept(true)
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if img == nil {
            self.profileViewModel.loadingBehavior.accept(false)
            self.view.makeToast("Can't upload pictures")
        }else{
            img?.upload(uid: uid, folder: "avata", completion: { (url) in
                DatabaseManager.auth.addAvataUser(url: url ) {[weak self] (bool) in
                    self?.profileViewModel.loadingBehavior.accept(false)
                    if bool {
                        self?.imgAvt.image = img
                        print("Save Image Succesfull")
                    }else {
                        print("NO")
                    }
                }
            })
        }
        
        
        
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
