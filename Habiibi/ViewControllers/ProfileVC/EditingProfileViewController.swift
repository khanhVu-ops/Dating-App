//
//  EdittingProfileViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 7/7/22.
//

import UIKit

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
    
    
    let profileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        profileViewModel.getListImg()
    }
    
    override func setUpView() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:))))
        vTopGradient.layer.cornerRadius = vTopGradient.frame.width/3
        
        cltvImage.dataSource = self
        cltvImage.delegate = self
        cltvImage.register(UINib(nibName: "EditProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EditProfileCollectionViewCell")
        cltvImage.register(UINib(nibName: "TakePhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TakePhotoCollectionViewCell")
        cltvImage.backgroundColor = .clear
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
        
        txtAboutMe.text = profileViewModel.userActive.about_me
        txtFavoriteFood.text = profileViewModel.userActive.favorite_food
        txtAboutMe.delegate = self
        txtFavoriteFood.delegate = self
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
    
}
extension EditingProfileViewController: UITextFieldDelegate {
    
}

extension EditingProfileViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 60)/3, height: (self.view.frame.width - 60)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
extension EditingProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        profileViewModel.getListImg()
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
            DatabaseManager.shared.updateProfileEditing(property: "about_me", text: text)

        }else {
            DatabaseManager.shared.updateProfileEditing(property: "favorite_food", text: text)

        }
    }
}





