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
    
    let homeViewModel = HomeScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async {
            self.vKoloda.reloadData()
        }
        
    }
    
    override func setUpView() {
        vKoloda.layer.cornerRadius = 20
//        vKoloda.layer.masksToBounds = true
        
        btnRight.layer.cornerRadius = btnRight.frame.height/2
        btnLeft.layer.cornerRadius = btnLeft.frame.height/2
        btnMid.layer.cornerRadius = btnMid.frame.height/2
        
        btnMid.layer.borderWidth = 5
        btnMid.layer.borderColor = UIColor.white.cgColor
        btnLeft.layer.borderWidth = 5
        btnLeft.layer.borderColor = UIColor.white.cgColor
        btnRight.layer.borderWidth = 5
        btnRight.layer.borderColor = UIColor.white.cgColor
        
        homeViewModel.setUpObservable()
        homeViewModel.getListUsers()
        vKoloda.delegate = self
        vKoloda.dataSource = self
        tbvImage.delegate = self
        tbvImage.dataSource = self
        tbvImage.register(UINib(nibName: "ListImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ListImageTableViewCell")
        homeViewModel.controller = self
        homeViewModel.vKoloda = vKoloda
        homeViewModel.heightTbvConstraint = heightTbvConstraint
        homeViewModel.tbvImg = tbvImage
        
        
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
//        print(homeViewModel.items.count)
        return homeViewModel.items.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = UIImageView()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.systemPink.cgColor
        view.layer.masksToBounds = true
        homeViewModel.imgAvt = view
        homeViewModel.notifiObserver(data: homeViewModel.items[index])
        return view
    }
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
//        print("IDSWIPE: \(index)")
        switch direction {
        case .left:
            print("LEFT")
            DatabaseManager.shared.addListUserInteraction(id: GobalData.id + 1, like: false)
        default:
            print("Right")
            DatabaseManager.shared.addListUserInteraction(id: GobalData.id + 1, like: true)
            
        }

    }
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
//        print("Show: \(index)")
        GobalData.id = index
        let count = homeViewModel.items[index].listImg?.count ?? 0
        heightTbvConstraint.constant = CGFloat(count*540)
        DispatchQueue.main.async {
            self.tbvImage.reloadData()
        }
        
    }
}

extension HomeScreenViewController: UITableViewDelegate {
    
    
}
extension HomeScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if homeViewModel.items.count > 0 {
            return homeViewModel.items[GobalData.id].listImg?.count ?? 0
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(indexPath.row)
        let cell = tbvImage.dequeueReusableCell(withIdentifier: "ListImageTableViewCell") as! ListImageTableViewCell
        cell.configure(item: homeViewModel.items[GobalData.id], row: indexPath.row)
        lbDescrip.text = homeViewModel.items[GobalData.id].descrip
        let name = homeViewModel.items[GobalData.id].name ?? ""
        let age = homeViewModel.items[GobalData.id].age ?? 0
        let country = homeViewModel.items[GobalData.id].location ?? ""
        lbName.text = "\(name), \(age) from \(country)"
        return cell
    }
    
    
    
}
