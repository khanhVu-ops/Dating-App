//
//  ProfileTableViewCell.swift
//  Habiibi
//
//  Created by KhanhVu on 7/6/22.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvt: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgAvt.layer.cornerRadius = 20
        imgAvt.layer.borderWidth = 2
        imgAvt.layer.borderColor = UIColor.systemPink.cgColor
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(imgStr: String) {
        imgAvt.image = imgStr.toImage()
        
    }
    
}
