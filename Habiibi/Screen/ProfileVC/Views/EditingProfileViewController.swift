//
//  EdittingProfileViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 7/7/22.
//

import UIKit
import RxSwift
import RxCocoa

class EditingProfileViewController: BaseViewController {


    @IBOutlet weak var heightCltvConstraint: NSLayoutConstraint!
    @IBOutlet weak var cltvImage: UICollectionView!
    @IBOutlet weak var txtAboutMe: UITextView!
    @IBOutlet weak var txtFavoriteFood: UITextView!
    @IBOutlet weak var heightTxtAboutMe: NSLayoutConstraint!
    @IBOutlet weak var heightTxtFvrFood: NSLayoutConstraint!
    @IBOutlet weak var vTopGradient: Gradient!
    @IBOutlet weak var vTxtAboutMe: UIView!
    @IBOutlet weak var vTxtFvrFood: UIView!
    @IBOutlet weak var btnEditAboutMe: UIButton!
    @IBOutlet weak var btnEditFvrFood: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var vBasicInfo: UIView!
    @IBOutlet weak var vEducation: UIView!
    @IBOutlet weak var tbvBasicInfo: UITableView!
    @IBOutlet weak var tbvEducation: UITableView!
    @IBOutlet weak var heightTbvInfoConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightTbvEducationConstraint: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    let profileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpObsevableTableView()
        subscribeToUpdateUI()
        subscribeToLoading()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        profileViewModel.fetchDataProfile()
//        profileViewModel.getListImg()
    }
    
    override func setUpView() {
//        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:))))
        vTopGradient.layer.cornerRadius = vTopGradient.frame.width/3
        
        cltvImage.dataSource = self
        cltvImage.delegate = self
        cltvImage.register(UINib(nibName: "EditProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EditProfileCollectionViewCell")
        cltvImage.register(UINib(nibName: "TakePhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TakePhotoCollectionViewCell")
        cltvImage.backgroundColor = .clear
        
        vBasicInfo.layer.cornerRadius = 20
        vBasicInfo.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        vBasicInfo.layer.shadowOpacity = 0.3
        vBasicInfo.layer.shadowColor = UIColor.gray.cgColor
        vBasicInfo.layer.shadowRadius = 10
        vEducation.layer.cornerRadius = 20
        vEducation.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        vEducation.layer.shadowOpacity = 0.3
        vEducation.layer.shadowColor = UIColor.gray.cgColor
        vEducation.layer.shadowRadius = 10
        
        tbvBasicInfo.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        tbvBasicInfo.backgroundColor = .clear
        tbvEducation.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        
        heightTxtAboutMe.isActive = false
        heightTxtFvrFood.isActive = false
        txtAboutMe.isScrollEnabled = false
        txtAboutMe.sizeToFit()
        txtFavoriteFood.isScrollEnabled = false
        txtFavoriteFood.sizeToFit()
        
        vTxtAboutMe.layer.cornerRadius = 20
        vTxtAboutMe.layer.masksToBounds = true
        vTxtAboutMe.layer.borderWidth = 1
        vTxtAboutMe.layer.borderColor = UIColor.gray.cgColor
        btnEditAboutMe.layer.cornerRadius = 10
        btnEditAboutMe.layer.borderWidth = 1

        
        vTxtFvrFood.layer.cornerRadius = 20
        vTxtFvrFood.layer.masksToBounds = true
        vTxtFvrFood.layer.borderWidth = 1
        vTxtFvrFood.layer.borderColor = UIColor.gray.cgColor
        btnEditFvrFood.layer.cornerRadius = 10
        btnEditFvrFood.layer.borderWidth = 1
        btnBack.imageView?.setImageColor(color: .white)
        
       
        txtAboutMe.delegate = self
        txtFavoriteFood.delegate = self
    }
    
    func setUpObsevableTableView() {
        heightTbvInfoConstraint.constant = CGFloat(6*120 + 60)
        heightTbvEducationConstraint.constant = CGFloat(2*120+60)
        
        profileViewModel.listEdit.bind(to: self.tbvBasicInfo.rx.items(cellIdentifier: "ProfileTableViewCell", cellType: ProfileTableViewCell.self)) { [weak self] row, item, cell in
            guard let item = self?.profileViewModel.listEdit.value[row] else {return}
            cell.configure(item: item)
            cell.editVC = self
        }
        .disposed(by: disposeBag)
        
        profileViewModel.listEducation.bind(to: self.tbvEducation.rx.items(cellIdentifier: "ProfileTableViewCell", cellType: ProfileTableViewCell.self)) { [weak self] row, item, cell in
            
            guard let item = self?.profileViewModel.listEducation.value[row] else {return}
            cell.configure(item: item)
            cell.editVC = self
        }
        .disposed(by: disposeBag)
    }
    
    func subscribeToUpdateUI() {
        profileViewModel.userActiveRelay.subscribe(onNext: { [weak self] data in
            self?.profileViewModel.getListImg()
            self?.profileViewModel.setUpTBV()
            self?.txtAboutMe.text = self?.profileViewModel.userActiveRelay.value.descripInfo
            self?.txtFavoriteFood.text = self?.profileViewModel.userActiveRelay.value.favoriteFood
            DispatchQueue.main.async {
                self?.cltvImage.reloadData()
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
    

    @IBAction func didTapBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func didTapBtnEditAboutMe(_ sender: Any) {
        txtAboutMe.becomeFirstResponder()
    }
    @IBAction func didTapBtnEditFvrFood(_ sender: Any) {
        txtFavoriteFood.becomeFirstResponder()
    }
    
    @IBAction func didTapBtnSave(_ sender: Any) {
        view.endEditing(true)
        DatabaseManager.auth.updateListImage(list: profileViewModel.listImg) { (bool) in
            if bool {
                print("oke")
            }else {
                print("No")
            }
        }
        
        let listWillSave = profileViewModel.listItemWillSave
        for item in listWillSave {
            DatabaseManager.auth.updateProfileEditing(property: item.title, text: item.tfText) { (bool) in
                if bool {
                    print("oke")
                }else {
                    print("No")
                }
            }
        }

        navigationController?.popViewController(animated: true)
        
    }
    
}


extension EditingProfileViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 60)/3, height: (self.view.frame.width - 60)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let count = profileViewModel.listImg.count
        if indexPath.item < count {
            profileViewModel.listImg.remove(at: indexPath.item)
            cltvImage.deleteItems(at: [indexPath])
        }
        
    }
}
extension EditingProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = profileViewModel.listImg.count
        let height = (self.view.frame.width - 60)/3
        if count < 6 {
            heightCltvConstraint.constant = CGFloat(height*2 + 15)
            return 6
        }else {
            let mul = count/3 + 1
            heightCltvConstraint.constant = CGFloat(height * CGFloat(mul) + 15*CGFloat(mul-1))
            return mul * 3
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let count = profileViewModel.listImg.count
        
        
        if indexPath.item == count {
            let cell = cltvImage.dequeueReusableCell(withReuseIdentifier: "TakePhotoCollectionViewCell", for: indexPath) as! TakePhotoCollectionViewCell
            cell.vc = self
            return cell
        }else {
            let cell = cltvImage.dequeueReusableCell(withReuseIdentifier: "EditProfileCollectionViewCell", for: indexPath) as! EditProfileCollectionViewCell
            if indexPath.item < count{
                let imgStr = profileViewModel.listImg[indexPath.item]
                cell.confifure(imgStr: imgStr)
                
            }else {
                cell.confifure(imgStr: "")
            }
            
            return cell
        }
        
    }
    
    
    
}
extension EditingProfileViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard  let text = textView.text else {
            return
        }
        if textView == txtAboutMe {
            profileViewModel.listItemWillSave.append(ModelSetUpTBV(title: "descripInfo", tfText: text, imgStr: ""))
//            DatabaseManager.shared.updateProfileEditing(property: "about_me", text: text)

        }else {
            profileViewModel.listItemWillSave.append(ModelSetUpTBV(title: "favoriteFood", tfText: text, imgStr: ""))
//            DatabaseManager.shared.updateProfileEditing(property: "favorite_food", text: text)

        }
    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//    }
}
