import UIKit
import InputBarAccessoryView
import Firebase
import MessageKit
import FirebaseFirestore
import SDWebImage
import RxSwift

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    
    let chatViewModel = ChatViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = chatViewModel.user2Name ?? "Chat"
        subscribeMessages()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        maintainPositionOnKeyboardFrameChanged = true
        scrollsToLastItemOnKeyboardBeginsEditing = true
        
        messageInputBar.inputTextView.tintColor = .systemBlue
        messageInputBar.sendButton.setTitleColor(.systemTeal, for: .normal)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        chatViewModel.loadChat()
        self.messagesCollectionView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0)
        
        setUpTopView()
    }
    
    
    func setUpTopView() {
        let vTop = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
       
        
        let btnBack = UIButton()
        let lbTitle = UILabel()
        self.view.addSubview(vTop)
        vTop.addSubview(btnBack)
        vTop.addSubview(lbTitle)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        btnBack.bottomAnchor.constraint(equalTo: vTop.bottomAnchor, constant: -10).isActive = true
        btnBack.leftAnchor.constraint(equalTo: vTop.leftAnchor, constant: 20).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btnBack.setImage(UIImage(named: "previous"), for: .normal)
        btnBack.addTarget(self, action: #selector(tapBtnBack), for: .touchUpInside)
        
        lbTitle.translatesAutoresizingMaskIntoConstraints = false
        lbTitle.text = chatViewModel.user2Name
        lbTitle.textAlignment = .center
        lbTitle.sizeToFit()
        lbTitle.font = UIFont.boldSystemFont(ofSize: 24.0)
        lbTitle.centerXAnchor.constraint(equalTo: vTop.centerXAnchor).isActive = true
        lbTitle.bottomAnchor.constraint(equalTo: vTop.bottomAnchor, constant: -5).isActive = true
        
        vTop.backgroundColor = .white
        vTop.layer.shadowOffset = CGSize(width: 1, height: 1)
        vTop.layer.shadowOpacity = 0.5
        vTop.layer.shadowColor = UIColor.gray.cgColor
    }
    // MARK: Target button
    
    
    @objc func tapBtnBack() {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func subscribeMessages() {
        chatViewModel.messages.subscribe(onNext: { [weak self] _ in
            DispatchQueue.main.async {
                self?.messagesCollectionView.reloadData()
                self?.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
            }
            
        })
        .disposed(by: disposeBag)
    }
    
    
    
    // MARK: - InputBarAccessoryViewDelegate
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: chatViewModel.currentUser.getUid(), senderName: chatViewModel.currentUser.getUsername())
        
        //messages.append(message)
        chatViewModel.insertNewMessage(message)
        chatViewModel.save(message)
        self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
    
    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        
        return Sender(id: chatViewModel.currentUser.getUid(), displayName:chatViewModel.currentUser.getUsername())
        
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return chatViewModel.messages.value[indexPath.section]
        
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        if chatViewModel.messages.value.count == 0 {
            print("No messages to display")
            return 0
        } else {
            return chatViewModel.messages.value.count
        }
    }
    
    
    // MARK: - MessagesLayoutDelegate
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    // MARK: - MessagesDisplayDelegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue: .lightGray
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if message.sender.senderId == chatViewModel.currentUser.getUid() {
            
            guard let url = URL(string: chatViewModel.currentUser.getAvataUrl()) else{
                return
            }
            SDWebImageManager.shared.loadImage(with: url, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        } else {
            SDWebImageManager.shared.loadImage(with: URL(string: chatViewModel.user2ImgUrl), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        }
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)
        
    }
    
}
