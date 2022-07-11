//
//  EditProfileCollectionViewCell.swift
//  Habiibi
//
//  Created by KhanhVu on 7/8/22.
//

import UIKit

class EditProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vCLTV: UIView!
    @IBOutlet weak var imvPicture: UIImageView!
    let index = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vCLTV.layer.cornerRadius = 20
        imvPicture.layer.cornerRadius = 20
        vCLTV.layer.masksToBounds = true
        
        // Initialization code
    }
    
    func confifure(imgStr: String) {
        if imgStr == "" {
            imvPicture.image = UIImage(named: "plus")
        }else {
            imvPicture.image = imgStr.toImage()
        }
        
    }
    
    func blureImage() {
        let inputImage = CIImage(cgImage: (self.imvPicture.image?.cgImage)!)
                        let filter = CIFilter(name: "CIGaussianBlur")
                        filter?.setValue(inputImage, forKey: "inputImage")
                        filter?.setValue(10, forKey: "inputRadius")
                        let blurred = filter?.outputImage

                        var newImageSize: CGRect = (blurred?.extent)!
                        newImageSize.origin.x += (newImageSize.size.width - (self.imvPicture.image?.size.width)!) / 2
                        newImageSize.origin.y += (newImageSize.size.height - (self.imvPicture.image?.size.height)!) / 2
                        newImageSize.size = (self.imvPicture.image?.size)!

                        let resultImage: CIImage = filter?.value(forKey: "outputImage") as! CIImage
                        let context: CIContext = CIContext.init(options: nil)
                        let cgimg: CGImage = context.createCGImage(resultImage, from: newImageSize)!
                        let blurredImage: UIImage = UIImage.init(cgImage: cgimg)
                        self.imvPicture.image = blurredImage
    }
    
    
   
}
