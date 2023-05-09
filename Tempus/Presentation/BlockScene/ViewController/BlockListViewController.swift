//
//  BlockListViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/09.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class BlockListViewController: UIViewController {
    var viewModel: BlockListViewModel?
    private let disposeBag: DisposeBag = .init()
    
    private var tableViewDataSource: UITableViewDiffableDataSource<Int, BlockModel>
    private let tableView: UITableView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BlockTableViewCell")
        
        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableViewDataSource = UITableViewDiffableDataSource<Int, BlockModel>(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BlockTableViewCell", for: indexPath)
            cell.textLabel?.text = model.title
            
            return cell
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
}

private extension BlockListViewController {
    func configureUI() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        let input = BlockListViewModel.Input(addButtonEvent: PublishSubject<Void>(),
                                             modelDeleteEvent: PublishSubject<BlockModel>(),
                                             modelFetchEvent: PublishSubject<Void>())
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {
            return
        }
        
        output.blockModelArray
            .subscribe(onNext: { models in
                // tableView snapshot update
            }).disposed(by: disposeBag)
            
        output.isDeleteSuccess
            .subscribe(onNext: { isDeleteSuccess in
                // Alert
            }).disposed(by: disposeBag)
    }
}
