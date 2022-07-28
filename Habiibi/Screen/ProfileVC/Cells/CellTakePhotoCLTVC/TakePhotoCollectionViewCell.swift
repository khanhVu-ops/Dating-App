//
//  TakePhotoCollectionViewCell.swift
//  Habiibi
//
//  Created by KhanhVu on 7/10/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class TakePhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vCltvc: UIView!
    var vc: EditingProfileViewController?
    let profileViewModel = ProfileViewModel()
    var imagePickerController = UIImagePickerController()
    override func awakeFromNib() {
        super.awakeFromNib()
        imagePickerController.delegate = self
        vCltvc.layer.cornerRadius = 20
        vCltvc.layer.masksToBounds = true
        // Initialization code
    }

    @IBAction func didTapBtnTakePhoto(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        vc?.present(imagePickerController, animated: true, completion: nil)
    }
}
extension TakePhotoCollectionViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .photoLibrary {
            vc?.profileViewModel.loadingBehavior.accept(true)
            let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            

            img?.upload(uid: uid, folder: "listImages", completion: { (url) in
                guard let urlStr = url else {return}
                self.vc?.profileViewModel.listImg.append("\(urlStr)")
//                self.vc?.profileViewModel.loadingBehavior.accept(false)
                DispatchQueue.main.async {
                    self.vc?.cltvImage.reloadData()
                }
//                let db = Firestore.firestore()
//                let listImagesRef = db.collection("users").document(uid)
//                listImagesRef.updateData([
//                    "listImages": FieldValue.arrayUnion(["\(urlStr)"])
//                ])
            })
            vc?.profileViewModel.loadingBehavior.accept(false)
//            let imgStr = img?.toJpegString(compressionQuality: 0) ?? ""
            
//            if imgStr.count > 0 {
////                profileViewModel.listImg.append(imgStr)
//
////                print(profileViewModel.listImg.count)
////                DatabaseManager.shared.addListImage(imgStr: imgStr)
////                print(profileViewModel.userActive.listImage.count)
//
//            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
