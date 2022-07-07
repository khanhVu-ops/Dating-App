//
//  EditProfileTableViewCell.swift
//  Habiibi
//
//  Created by KhanhVu on 7/7/22.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        img.layer.cornerRadius = 20
        img.layer.borderWidth = 2
        img.layer.borderColor = UIColor.systemPink.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(imgStr: String) {
        img.image = imgStr.toImage()
    }
    
    
}
