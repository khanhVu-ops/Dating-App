//
//  ListImageTableViewCell.swift
//  Habiibi
//
//  Created by KhanhVu on 7/6/22.
//

import UIKit
import SDWebImage

class ListImageTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        img.layer.cornerRadius = 20
        img.layer.borderWidth = 3
        img.layer.borderColor = UIColor.systemPink.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(item: UserModel, row: Int) {
        let imgStr = item.listImg?[row] ?? ""
//        print(imgStr)
        img.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "img_placeHolder"))
    }
    
}
