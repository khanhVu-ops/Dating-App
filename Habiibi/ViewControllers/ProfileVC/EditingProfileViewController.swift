//
//  EdittingProfileViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 7/7/22.
//

import UIKit

class EditingProfileViewController: BaseViewController {
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var vEditFirstName: UIView!
    @IBOutlet weak var vEditLastName: UIView!
    @IBOutlet weak var vEditCountry: UIView!
    @IBOutlet weak var btnAddPicture: UIButton!
    @IBOutlet weak var tfEditFirstName: UITextField!
    @IBOutlet weak var tfEditLastName: UITextField!
    @IBOutlet weak var tfEditCountry: UITextField!
    @IBOutlet weak var vAddPicture: UIView!
    @IBOutlet weak var tbvImg: UITableView!
    @IBOutlet weak var heightTbvConstraint: NSLayoutConstraint!
    
    var imagePickerController = UIImagePickerController()
    
    let profileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        imagePickerController.delegate = self
    }
    
    override func setUpView() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:))))
        vAddPicture.layer.borderWidth = 2
        vAddPicture.layer.borderColor = UIColor.systemPink.cgColor
        vAddPicture.layer.cornerRadius = 20
        vAddPicture.layer.masksToBounds = true
        vEditFirstName.layer.borderWidth = 2
        vEditFirstName.layer.borderColor = UIColor.systemPink.cgColor
        vEditFirstName.layer.cornerRadius = 20
        vEditLastName.layer.borderWidth = 2
        vEditLastName.layer.borderColor = UIColor.systemPink.cgColor
        vEditLastName.layer.cornerRadius = 20
        vEditCountry.layer.borderWidth = 2
        vEditCountry.layer.borderColor = UIColor.systemPink.cgColor
        vEditCountry.layer.cornerRadius = 20
        
        btnSave.layer.borderWidth = 2
        btnSave.layer.borderColor = UIColor.gray.cgColor
        btnSave.layer.cornerRadius = 10
        
//        btnUpdatePicture.layer.borderWidth = 2
//        btnUpdatePicture.layer.borderColor = UIColor.gray.cgColor
//        btnUpdatePicture.layer.cornerRadius = 20
        tfEditFirstName.delegate = self
        tfEditLastName.delegate = self
        tfEditCountry.delegate = self
        tbvImg.delegate = self
        tbvImg.dataSource = self
        tbvImg.register(UINib(nibName: "EditProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "EditProfileTableViewCell")
        heightTbvConstraint.constant = CGFloat(0.0)
        profileViewModel.tfEditCountry = tfEditCountry
        profileViewModel.tfEditLastName = tfEditLastName
        profileViewModel.tfEditFirstName = tfEditFirstName
        profileViewModel.tbvImgEdit = tbvImg
        
        profileViewModel.setUpTextInTextField()
    }

    @IBAction func didTapBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didTapBtnSave(_ sender: Any) {
        profileViewModel.saveDataEdited()
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didTapBtnAddPicture(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
}
extension EditingProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateButtonUI(btnSave, enable: false, color: .systemPink)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonUI(btnSave, enable: true, color: .systemPink)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case tfEditFirstName:
            tfEditLastName.becomeFirstResponder()
        case tfEditLastName:
            tfEditCountry.becomeFirstResponder()
        default:
            tfEditCountry.resignFirstResponder()
        }
        return true
    }
}

extension EditingProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .photoLibrary {
            let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            let imgStr = img?.toJpegString(compressionQuality: 0) ?? ""
            if imgStr.count > 0 {
                profileViewModel.listImg.append(imgStr)
                DispatchQueue.main.async {
                    self.tbvImg.reloadData()
                }
            }
//            print("IMG: \(String(describing: imgStr))")
//            imgAvt?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//            DatabaseManager.shared.addListImage(string: imgStr ?? "")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditingProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("ROW: \(indexPath.row)")
            profileViewModel.listImg.remove(at: indexPath.row)
            tbvImg.reloadData()
        }
    }
}
extension EditingProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = profileViewModel.listImg.count
        heightTbvConstraint.constant = CGFloat(count*420)
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        let cell = tbvImg.dequeueReusableCell(withIdentifier: "EditProfileTableViewCell") as! EditProfileTableViewCell
        cell.configure(imgStr: profileViewModel.listImg[indexPath.row])
        return cell
    }
    
    
    
}

