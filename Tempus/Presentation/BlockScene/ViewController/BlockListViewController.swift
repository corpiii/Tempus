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
    private enum Section {
        case main
    }
    
    var viewModel: BlockListViewModel?
    private let disposeBag: DisposeBag = .init()
    
    private var tableViewDataSource: UITableViewDiffableDataSource<Section, BlockModel>
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BlockTableViewCell")
        
        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableViewDataSource = UITableViewDiffableDataSource<Section, BlockModel>(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in
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


// MARK: - ConfigureUI
private extension BlockListViewController {
    func configureUI() {
        configureTableView()
    }
    
    func configureTableView() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.dataSource = tableViewDataSource
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, BlockModel>()
        snapShot.appendSections([.main])
        tableViewDataSource.apply(snapShot)
    }
}

// MARK: - BindViewModel
private extension BlockListViewController {
    func bindViewModel() {
        let input = BlockListViewModel.Input(addButtonEvent: PublishSubject<Void>(),
                                             modelDeleteEvent: PublishSubject<BlockModel>(),
                                             modelFetchEvent: PublishSubject<Void>())
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {
            return
        }
        
        output.blockModelArray
            .subscribe(onNext: { models in
                var snapshot = NSDiffableDataSourceSnapshot<Section, BlockModel>()
                snapshot.appendSections([.main])
                snapshot.appendItems(models)
                
                self.tableViewDataSource.apply(snapshot)
            }).disposed(by: disposeBag)
        
        output.isDeleteSuccess
            .subscribe(onNext: { isDeleteSuccess in
                // Alert
            }).disposed(by: disposeBag)
    }
}
