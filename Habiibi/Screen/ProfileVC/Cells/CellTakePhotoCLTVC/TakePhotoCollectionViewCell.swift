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
            
            guard let uid = Auth.auth().currentUser?.uid else {
                self.vc?.profileViewModel.loadingBehavior.accept(false)
                return
                
            }
            
            if img == nil {
                self.vc?.profileViewModel.loadingBehavior.accept(false)
                self.vc?.view.makeToast("Can't upload pictures")
                
            }else {
                img?.upload(uid: uid, folder: "listImages", completion: { [weak self] (url) in
                    guard let urlStr = url else {
                        self?.vc?.profileViewModel.loadingBehavior.accept(false)
                        return
                        
                    }
                    var newList = self?.vc?.profileViewModel.listtImagesTemporary.value ?? []
                    newList = newList.filter({$0 != ""})
                    newList.append("\(urlStr)")
                    
                    if (newList.count) < 6 {
                        for _ in newList.count..<6 {
                            newList.append("")
                        }
                    }else {
                        let mul = (newList.count/3 + 1)*3
                        for _ in newList.count..<mul {
                            newList.append("")
                        }
                    }
                    self?.vc?.profileViewModel.listtImagesTemporary.accept(newList)
                    
                   
                    self?.vc?.profileViewModel.loadingBehavior.accept(false)
                })
            }
            
        } else {
            self.vc?.profileViewModel.loadingBehavior.accept(false)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
