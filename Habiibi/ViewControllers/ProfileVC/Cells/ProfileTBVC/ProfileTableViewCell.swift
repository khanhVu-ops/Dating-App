//
//  ProfileTableViewCell.swift
//  Habiibi
//
//  Created by KhanhVu on 7/6/22.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvt: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tfEnter: UITextField!
    @IBOutlet weak var btnEdit: UIButton!
    
    var property = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self.contentView, action: #selector(self.contentView.endEditing(_:))))
        imgAvt.layer.cornerRadius = 20
        imgAvt.layer.borderWidth = 2
        imgAvt.layer.borderColor = UIColor.systemPink.cgColor
        
        btnEdit.layer.borderWidth = 1
        btnEdit.layer.cornerRadius = 10
        btnEdit.layer.borderColor = UIColor.gray.cgColor
        tfEnter.delegate = self
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func didTapBtnEdit(_ sender: Any) {
        tfEnter.becomeFirstResponder()
    }
    
    func configure(item: ModelSetUpTBV) {
        imgAvt.image = UIImage(named: item.imgStr)
        imgAvt.setImageColor(color: .white)
        lbName.text = item.title
        tfEnter.placeholder = item.title
        tfEnter.text = item.tfText
        property = item.imgStr
        
    }
    
}

extension ProfileTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        DatabaseManager.shared.updateProfileEditing(property: property, text: text)
    }
    
}
