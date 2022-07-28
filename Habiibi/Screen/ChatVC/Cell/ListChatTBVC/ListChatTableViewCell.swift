//
//  ListChatTableViewCell.swift
//  Habiibi
//
//  Created by KhanhVu on 7/27/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class ListChatTableViewCell: UITableViewCell {
    @IBOutlet weak var imgAvt: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbNewMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpView()
        // Initialization code
    }
    func setUpView() {
        imgAvt.layer.cornerRadius = imgAvt.frame.height/2
        imgAvt.layer.borderWidth = 1
        imgAvt.layer.borderColor = UIColor.systemPink.cgColor
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with data: Chat, docRef: DocumentReference) {
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        let uidDiffrent = data.users.filter({$0 != uid})
        
        
        docRef.collection("thread").order(by: "created",descending: true).limit(to: 1).addSnapshotListener { [weak self] (snapshot, error) in
            guard let snapshot = snapshot , error == nil else{
                return
            }
            for mess in snapshot.documents {
                let msg = Message(dictionary: mess.data())
                self?.lbNewMessage.text = msg?.content
            }
            
        }
        DatabaseManager.auth.fetchDataUser(uid: uidDiffrent[0]) {[weak self] (user, error) in
            guard let user = user , error == nil else{return}
            guard let url = URL(string: user.avata ?? "") else{return}
            
            self?.imgAvt.sd_setImage(with: url, placeholderImage: UIImage(named: "img_placeHolder"))
            self?.lbName.text = user.userName
            
        }
        
        
        
    }

}
