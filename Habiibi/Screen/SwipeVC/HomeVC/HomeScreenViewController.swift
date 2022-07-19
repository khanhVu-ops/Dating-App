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
    
    let disposeBag = DisposeBag()
    let homeViewModel = HomeScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setUpView()
        subscribeToLoading()
        setUpTableViewListImage()
        subcribseToFilterVC()
        bindToLabel()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        homeViewModel.getListUsers()
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
    }
    @IBAction func didTapBtnRight(_ sender: Any) {
        vKoloda.swipe(.right)
        DatabaseManager.shared.addListUserInteraction(id: GobalData.id + 1, like: true)
    }
    
    @IBAction func didTapBtnLeft(_ sender: Any) {
        vKoloda.swipe(.left)
        DatabaseManager.shared.addListUserInteraction(id: GobalData.id + 1, like: false)
    }
}


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
            view.image = UIImage(named: avt)
            return view
        }
        return UIView()
        
    }
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
                print("IDSWIPE: \(index)")
        
        heightTbvConstraint.constant = CGFloat(0*540)
        let item = homeViewModel.listItemsBehavior.value
        if index<item.count {
            guard let id = homeViewModel.listItemsBehavior.value[index].id else {
                return
            }
            
            switch direction {
            case .left:
                print("LEFT")
                DatabaseManager.shared.addListUserInteraction(id: id, like: false)
            default:
                print("Right")
                DatabaseManager.shared.addListUserInteraction(id: id, like: true)
                
            }
        }
        
        
    }
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        GobalData.id = index
        
        homeViewModel.emittedListimage(index: index)
        
        
    }
    
}

extension HomeScreenViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
