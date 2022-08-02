//
//  File.swift
//  Habiibi
//
//  Created by KhanhVu on 7/6/22.
//

import Foundation
import UIKit
import FirebaseStorage
extension UIImage {
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
    
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
    
    
    func upload(uid: String, folder: String, completion: @escaping (URL?) -> Void) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        //let fileName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let data = self.jpegData(compressionQuality: 0.0)
        let storage = Storage.storage().reference()
        storage.child(uid).child(folder).putData(data!, metadata: metadata) { meta, error in
            if let error = error {
                print(error)
                completion(nil)
                return
            }

            storage.child(uid).child(folder).downloadURL { url, error in
                if let error = error {
                    // Handle any errors
                    print(error)
                    
                    completion(nil)
                }
                else {
                    completion(url)
                }
            }
        }
    }
    
}
extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
