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
    
    private let addButton: UIBarButtonItem = .init(systemItem: .add)
    private let modelDeleteEvent: PublishSubject<BlockModel> = .init()
    private let modelTapEvent: PublishSubject<BlockModel> = .init()
    private let modelFechEvent: PublishSubject<Void> = .init()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableViewDataSource = UITableViewDiffableDataSource<Section, BlockModel>(tableView: tableView)
        { (tableView, indexPath, model) -> UITableViewCell? in
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
        modelFechEvent.onNext(())
    }
}


// MARK: - ConfigureUI
private extension BlockListViewController {
    func configureUI() {
        configureNavigationBar()
        configureTableView()
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "일상모드"
        
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func configureTableView() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = tableViewDataSource
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, BlockModel>()
        snapShot.appendSections([.main])
        tableViewDataSource.apply(snapShot)
    }
}

// MARK: - BindViewModel
private extension BlockListViewController {
    func bindViewModel() {
        let input = BlockListViewModel.Input(addButtonEvent: addButton.rx.tap.asObservable(),
                                             modelDeleteEvent: modelDeleteEvent,
                                             modelFetchEvent: modelFechEvent,
                                             modelTapEvent: modelTapEvent)
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {
            return
        }
        
        bindBlockModelArray(output.blockModelArray)
        bindDeleteResult(output.isDeleteSuccess)
    }
    
    func bindBlockModelArray(_ blockModelArray: Observable<[BlockModel]>) {
        blockModelArray
            .subscribe(onNext: { models in
                var snapshot = NSDiffableDataSourceSnapshot<Section, BlockModel>()
                snapshot.appendSections([.main])
                snapshot.appendItems(models)
                
                self.tableViewDataSource.apply(snapshot)
            }).disposed(by: disposeBag)
    }
    
    func bindDeleteResult(_ isDeleteSuccess: PublishRelay<Result<BlockModel, DataManageError>>) {
        isDeleteSuccess
            .subscribe(onNext: { [weak self] result in
                guard let self else { return }
                if case .success(let model) = result {
                    var snapshot = self.tableViewDataSource.snapshot()
                    snapshot.deleteItems([model])
                    
                    self.tableViewDataSource.apply(snapshot)
                } else if case .failure(let error) = result {
                    let alertController = UIAlertController(title: "알림",
                                                            message: error.errorDescription,
                                                            preferredStyle: .alert)
                    
                    let confirmAction = UIAlertAction(title: "확인", style: .default)
                    alertController.addAction(confirmAction)
                    
                    self.present(alertController, animated: true)
                }
                
            }).disposed(by: disposeBag)
    }
}

extension BlockListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let snapShot = tableViewDataSource.snapshot()
        let model = snapShot.itemIdentifiers[indexPath.row]
        
        modelTapEvent.onNext(model)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, success in
            guard let self else { return }
            
            let snapshot = self.tableViewDataSource.snapshot()
            let model = snapshot.itemIdentifiers[indexPath.row]
            
            self.modelDeleteEvent.onNext(model)
            success(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
