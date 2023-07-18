//
//  DailyListViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/03.
//

import UIKit

import RxRelay
import RxSwift
import SnapKit

final class DailyListViewController: UIViewController {
    private weak var viewModel: DailyListViewModel?
    private let disposeBag: DisposeBag = .init()
    
    private let tableViewDataSourceManager: DailyTableViewDataSourceManager
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = ColorConstant.backGroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let addButton: UIBarButtonItem = .init(systemItem: .add)
    private let modelDeleteEvent: PublishSubject<DailyModel> = .init()
    private let modelTapEvent: PublishSubject<DailyModel> = .init()
    private let modelFetchEvent: PublishSubject<Void> = .init()
    
    init(viewModel: DailyListViewModel) {
        self.viewModel = viewModel
        self.tableViewDataSourceManager = .init(tableView: tableView)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bindViewModel()
        modelFetchEvent.onNext(())
    }
}

// MARK: - ConfigureUI
private extension DailyListViewController {
    func configureUI() {
        configureNavigationBar()
        configureTableView()
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = I18NStrings.NavigationItem.dailyListTitle
        
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func configureTableView() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
    }
}

// MARK: - BindViewModel
private extension DailyListViewController {
    func bindViewModel() {
        let input = DailyListViewModel.Input(addButtonEvent: addButton.rx.tap.asObservable(),
                                             modelDeleteEvent: modelDeleteEvent,
                                             modelFetchEvent: modelFetchEvent,
                                             modelTapEvent: modelTapEvent)
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {
            return
        }
        
        bindDailyModelArray(output.dailyModelArray)
        bindDeleteResult(output.isDeleteSuccess)
    }
    
    func bindDailyModelArray(_ blockModelArray: Observable<[DailyModel]>) {
        blockModelArray
            .subscribe(onNext: { [weak self] models in
                self?.tableViewDataSourceManager.apply(section: .main, models: models)
            }).disposed(by: disposeBag)
    }
    
    func bindDeleteResult(_ isDeleteSuccess: PublishRelay<Result<DailyModel, DataManageError>>) {
        isDeleteSuccess
            .subscribe(onNext: { [weak self] result in
                if case .success(let model) = result {
                    self?.tableViewDataSourceManager.delete(model: model)
                } else if case .failure(let error) = result {
                    let alertController = UIAlertController(title: I18NStrings.Alert.alertTitle,
                                                            message: error.errorDescription,
                                                            preferredStyle: .alert)
                    
                    let confirmAction = UIAlertAction(title: I18NStrings.Alert.confirmAction, style: .default)
                    alertController.addAction(confirmAction)
                    
                    self?.present(alertController, animated: true)
                }
                
            }).disposed(by: disposeBag)
    }
}

extension DailyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = tableViewDataSourceManager.fetch(index: indexPath.row)
        
        modelTapEvent.onNext(model)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: I18NStrings.Alert.deleteAction) { [weak self] _, _, success in
            guard let self else { return }
            let model = self.tableViewDataSourceManager.fetch(index: indexPath.row)
            
            self.modelDeleteEvent.onNext(model)
            success(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
