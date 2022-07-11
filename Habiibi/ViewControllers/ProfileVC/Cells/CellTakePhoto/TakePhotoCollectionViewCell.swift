//
//  TakePhotoCollectionViewCell.swift
//  Habiibi
//
//  Created by KhanhVu on 7/10/22.
//

import UIKit

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
            let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            let imgStr = img?.toJpegString(compressionQuality: 0) ?? ""
            if imgStr.count > 0 {
//                profileViewModel.listImg.append(imgStr)
                vc?.profileViewModel.listImg.append(imgStr)
//                print(profileViewModel.listImg.count)
//                DatabaseManager.shared.addListImage(imgStr: imgStr)
//                print(profileViewModel.userActive.listImage.count)
                DispatchQueue.main.async {
                    self.vc?.cltvImage.reloadData()
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
