//
//  SearchViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 7/28/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol DismissedProtocol {
    func dismissed(friend: FriendModel)
}

class SearchViewController: BaseViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tbvListResult: UITableView!
    
    @IBOutlet weak var lbNoResult: UILabel!
    
    var delegateDismiss: DismissedProtocol? = nil
    
    let disposeBag = DisposeBag()
    
    let messageViewModel = MessageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageViewModel.getListFriend()
        subscribeToSearchBar()
        subscribeToTbv()
        setupCellTapHandling()
        tbvListResult.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    func subscribeToTbv(){
        messageViewModel.listResSearch.bind(to: self.tbvListResult.rx.items(cellIdentifier: "SearchTableViewCell", cellType: SearchTableViewCell.self)) { row, item, cell in
            
            cell.configure(with: item)
            
        }.disposed(by: disposeBag)
    }
    
    func subscribeToSearchBar() {
        searchBar
            .rx.text
            .orEmpty
            .debounce(.seconds(Int(0.5)), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            // If they didn't occur, check if the new value is the same as old.
            .filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                let list = messageViewModel.listFriendBehavior.value
                
                let newVal = list.filter({($0.userName?.lowercased() ?? "").hasPrefix(query)})
                if newVal.count>0 {
                    tbvListResult.isHidden = false
                }else{
                    tbvListResult.isHidden = true
                }
                self.messageViewModel.listResSearch.accept(newVal)// We now do our "API Request" to find cities.
                
            })
            .disposed(by: disposeBag)
    }
    
    func setupCellTapHandling() {
        tbvListResult
            .rx
            .modelSelected(FriendModel.self)
            .subscribe(onNext: {[weak self] item in
                
                if let selectedRowIndexPath = self?.tbvListResult.indexPathForSelectedRow {
                    self?.tbvListResult.deselectRow(at: selectedRowIndexPath, animated: true)
                }
//                vc.modalPresentationStyle = .fullScreen
//                self?.present(vc, animated: true, completion: nil)
//
                
                self?.dismiss(animated: true, completion: {
                    self?.delegateDismiss?.dismissed(friend: item)
                })
//                self?.present(vc, animated: true, completion: nil)
//                self?.navigationController?.pushViewController(vc, animated: true)
  
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func didTapBtnCancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
