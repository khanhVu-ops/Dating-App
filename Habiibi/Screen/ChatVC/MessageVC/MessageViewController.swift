//
//  MessageViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 7/26/22.
//

import UIKit
import RxSwift
import RxCocoa


class MessageViewController: BaseViewController {
   
    @IBOutlet weak var cltvListFriend: UICollectionView!
    @IBOutlet weak var tbvListChat: UITableView!
    
    
    let messageViewModel = MessageViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        subscribeTableViewListChats()
        subscribeCLTVListFriend()
        setupCellTapHandling()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        messageViewModel.getListFriend()
        messageViewModel.getListChat()
    }
    override func setUpView() {
//        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:))))
        
        tbvListChat.register(UINib(nibName: "ListChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ListChatTableViewCell")
        
    
        cltvListFriend.register(UINib(nibName: "ListFriendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListFriendCollectionViewCell")
        
        cltvListFriend.dataSource = self
        cltvListFriend.delegate = self
    }
    
    //MARK: Subscribe
    
    func subscribeCLTVListFriend() {
        messageViewModel.listFriendBehavior.subscribe(onNext: { [weak self] _ in

            DispatchQueue.main.async {
                self?.cltvListFriend.reloadData()
            }
            
        })
        .disposed(by: disposeBag)
    }
    
    func subscribeTableViewListChats() {
        
        messageViewModel.listChatBehavior.bind(to: self.tbvListChat.rx.items(cellIdentifier: "ListChatTableViewCell", cellType: ListChatTableViewCell.self)) { [weak self] row, item, cell in
            
            guard let doc = self?.messageViewModel.listDocument[row] else{
                return
            }
            cell.configure(with: item, docRef:  doc)
          
        }
        .disposed(by: disposeBag)
        

        
    }
    func setupCellTapHandling() {
      tbvListChat
        .rx
        .modelSelected(Chat.self)
        .subscribe(onNext: {[weak self] item in
            let st = UIStoryboard(name: "Main", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            let uid = item.users.filter({$0 != ManagerUserdefaults.shared.getUid()})
            vc.chatViewModel.user2UID = uid[0]
            if let selectedRowIndexPath = self?.tbvListChat.indexPathForSelectedRow {
              self?.tbvListChat.deselectRow(at: selectedRowIndexPath, animated: true)
            }
            DatabaseManager.auth.fetchDataUser(uid: uid[0]) { [weak self] (user, error) in
                guard let user = user, error == nil else {
                    return
                }
                
                
                vc.chatViewModel.user2ImgUrl = user.avata ?? ""
                vc.chatViewModel.user2Name = user.userName ?? ""
                self?.navigationController?.pushViewController(vc, animated: true)
                
                
            }
            
            
        })
        .disposed(by: disposeBag)
    }
    
//MARK: Action
    
    @IBAction func didTapBtnFilter(_ sender: Any) {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.delegateDismiss = self
        self.present(vc, animated: true, completion: nil)
    }
    
}

// MARK: Extensions

extension MessageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageViewModel.listFriendBehavior.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltvListFriend.dequeueReusableCell(withReuseIdentifier: "ListFriendCollectionViewCell", for: indexPath) as! ListFriendCollectionViewCell
        cell.configure(with: messageViewModel.listFriendBehavior.value[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cltvListFriend.frame.height-20, height: cltvListFriend.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = messageViewModel.listFriendBehavior.value[indexPath.row]
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.chatViewModel.user2UID = item.uid ?? ""
        vc.chatViewModel.user2ImgUrl = item.avata ?? ""
        vc.chatViewModel.user2Name = item.userName ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MessageViewController: DismissedProtocol {
    func  dismissed(friend: FriendModel) {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.chatViewModel.user2UID = friend.uid ?? ""
        vc.chatViewModel.user2ImgUrl = friend.avata ?? ""
        vc.chatViewModel.user2Name = friend.userName ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
