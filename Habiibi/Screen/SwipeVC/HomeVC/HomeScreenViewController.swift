//
//  HomeScreenViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/22/22.
//

import UIKit
import RxSwift
import RxCocoa
import FBSDKLoginKit
import Koloda
import FirebaseFirestore
import FirebaseAuth
class HomeScreenViewController: BaseViewController {
    
    @IBOutlet weak var vKoloda: KolodaView!
    @IBOutlet weak var lbDescrip: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tbvImage: UITableView!
    @IBOutlet weak var heightTbvConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnMid: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var lbNoPerson: UILabel!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var lbCountTym: UILabel!
    
    let disposeBag = DisposeBag()
    let homeViewModel = HomeScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UID: \(String(describing: Auth.auth().currentUser?.uid))")

        setUpView()
        subscribeToLoading()
        setUpTableViewListImage()
        subcribseToFilterVC()
        subscribeToCountTym()
        bindToLabel()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        homeViewModel.getListUsers()
        homeViewModel.getListUserTym()
        lbName.text = "-__-"
        lbDescrip.text = ""
        DispatchQueue.main.async {
            self.vKoloda.reloadData()
        }
        
    }
    
    override func setUpView() {
        lbNoPerson.isHidden = true
        vKoloda.layer.cornerRadius = 20
        
        btnRight.layer.cornerRadius = btnRight.frame.height/2
        btnLeft.layer.cornerRadius = btnLeft.frame.height/2
        btnMid.layer.cornerRadius = btnMid.frame.height/2
        lbCountTym.layer.cornerRadius = lbCountTym.frame.width/2
        lbCountTym.layer.masksToBounds = true
        btnMid.layer.borderWidth = 5
        btnMid.layer.borderColor = UIColor.white.cgColor
        btnLeft.layer.borderWidth = 5
        btnLeft.layer.borderColor = UIColor.white.cgColor
        btnRight.layer.borderWidth = 5
        btnRight.layer.borderColor = UIColor.white.cgColor
        vKoloda.delegate = self
        vKoloda.dataSource = self
        
        tbvImage.register(UINib(nibName: "ListImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ListImageTableViewCell")
        homeViewModel.vKoloda = vKoloda
        homeViewModel.heightTbvConstraint = heightTbvConstraint
        vKoloda.layer.cornerRadius = 20
        vKoloda.layer.borderWidth = 1
        vKoloda.layer.borderColor = UIColor.systemPink.cgColor
        
        
        
        
        
        
    }
    
    //MARK: Subscriber
    func subscribeToLoading() {
        homeViewModel.loadingBehavior.subscribe(onNext: { isLoading in
            if isLoading {
                self.showIndicator(withTitle: "", and: "")
            }else{
                self.hideIndicator()
            }
            
        })
        .disposed(by: disposeBag)
    }
    
    func setUpTableViewListImage() {
        homeViewModel.listImagesBehavior.bind(to: self.tbvImage.rx.items(cellIdentifier: "ListImageTableViewCell", cellType: ListImageTableViewCell.self)) { row, item, cell in
            cell.configure(item: item, row: row)
          
        }
        .disposed(by: disposeBag)
    }
    
    func bindToLabel() {
        homeViewModel.txtName.subscribe(onNext: { [weak self] txt in
            self?.lbName.text = txt
        })
        .disposed(by: disposeBag)
        
        homeViewModel.txtDescrip.subscribe(onNext: { [weak self] txt in
            self?.lbDescrip.text = txt
        })
        .disposed(by: disposeBag)
    }
    
    
    
    func subcribseToFilterVC() {
        homeViewModel.filterRelay.subscribe(onNext: { [weak self] _ in
            
            guard let self = self else {return}
            self.homeViewModel.getListUsers()
            
        })
        .disposed(by: disposeBag)
    }
    
    func subscribeToCountTym() {
        homeViewModel.countTymBehavior.subscribe(onNext: { [weak self] value in
            if value == 0 {
                self?.lbCountTym.isHidden = true
            }else {
                self?.lbCountTym.isHidden = false
            }
            self?.lbCountTym.text = "\(value)"
        })
        .disposed(by: disposeBag)
    }
    
    
    //MARK: ACTION
    @IBAction func didTapBtnFilter(_ sender: Any) {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let popoverContent = st.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        popoverContent.homeVC = self
//        popoverContent.delegate = self
        popoverContent.modalPresentationStyle = .popover
        if let popover = popoverContent.popoverPresentationController {
            popover.delegate = self
            let viewForSource = sender as! UIView
            popover.sourceView = viewForSource
            
            popover.sourceRect = viewForSource.bounds
            popoverContent.preferredContentSize = CGSize(width: 300, height: 300)
            
        }
        self.present(popoverContent, animated: true, completion: nil)
        
    }
    @IBAction func didTapBtnReload(_ sender: Any) {
        homeViewModel.getListUsers()
        DispatchQueue.main.async {
            self.vKoloda.resetCurrentCardIndex()
        }
    }
    
    @IBAction func didTapBtnMid(_ sender: Any) {
        
        if homeViewModel.getUidUserDidShow() != "" {
            let st = UIStoryboard(name: "Main", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            
            vc.chatViewModel.user2UID = homeViewModel.getUidUserDidShow()
            vc.chatViewModel.user2ImgUrl = homeViewModel.getAvataUrlUserDidShow()
            vc.chatViewModel.user2Name = homeViewModel.getNameUserDidShow()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    @IBAction func didTapBtnRight(_ sender: Any) {
        vKoloda.swipe(.right)
        DatabaseManager.auth.addUserInteraction(uid: homeViewModel.getUidUserDidShow(),username: homeViewModel.getNameUserDidShow(), avata: homeViewModel.getAvataUrlUserDidShow(), like: true)
    }
    
    @IBAction func didTapBtnLeft(_ sender: Any) {
        vKoloda.swipe(.left)
        DatabaseManager.auth.addUserInteraction(uid: homeViewModel.getUidUserDidShow(),username: homeViewModel.getNameUserDidShow(), avata: homeViewModel.getAvataUrlUserDidShow(), like: false)
    }
}
//MARK: Extentions

extension HomeScreenViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        homeViewModel.getListUsers()
        DispatchQueue.main.async {
            self.vKoloda.resetCurrentCardIndex()
        }
    }
}
extension HomeScreenViewController: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        let count = homeViewModel.listItemsBehavior.value.count
        if count == 0 {
            homeViewModel.uidUserDidShow = ""
            homeViewModel.nameUserDidShow = ""
            homeViewModel.avataUrlDidShow = ""
            lbNoPerson.isHidden = false
            heightTbvConstraint.constant = CGFloat(0)
        }
        return count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = UIImageView()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemPink.cgColor
        view.layer.masksToBounds = true
        let item = homeViewModel.listItemsBehavior.value
        if index < item.count {
            guard let avt = item[index].avata else {
                return UIView()
                
            }
            guard let url = URL(string: avt) else{return UIView()}
            view.sd_setImage(with: url, placeholderImage: UIImage(named: "img_placeHolder"))
            return view
        }
        return UIView()
        
    }
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
                print("IDSWIPE: \(index)")
        
        heightTbvConstraint.constant = CGFloat(0*540)
        let item = homeViewModel.listItemsBehavior.value
        if index<item.count {
//            guard let id = homeViewModel.listItemsBehavior.value[index].age else {
//                return
//            }
//            
            switch direction {
            case .left:
                print("LEFT")
                DatabaseManager.auth.addUserInteraction(uid: homeViewModel.getUidUserDidShow(),username: homeViewModel.getNameUserDidShow(), avata: homeViewModel.getAvataUrlUserDidShow(), like: false)
            default:
                print("Right")
                DatabaseManager.auth.addUserInteraction(uid: homeViewModel.getUidUserDidShow(),username: homeViewModel.getNameUserDidShow(), avata: homeViewModel.getAvataUrlUserDidShow(), like: true)
                
            }
        }
        
        
    }
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        GobalData.id = index
        homeViewModel.setUserDidShow(index: index)
        homeViewModel.emittedListimage(index: index)
        
        
    }
    
}

extension HomeScreenViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
