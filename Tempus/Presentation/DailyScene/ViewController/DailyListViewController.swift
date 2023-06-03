//
//  DailyListViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/03.
//

import UIKit

import RxSwift
import SnapKit

class DailyListViewController: UIViewController {
    
    private weak var viewModel: DailyListViewModel?
    private let disposeBag: DisposeBag
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
//    private let tableViewDataSourceManager: BlockTableViewDataSourceManager
    private let addButton: UIBarButtonItem = .init(systemItem: .add)
    private let modelDeleteEvent: PublishSubject<DailyModel> = .init()
    private let modelTapEvent: PublishSubject<DailyModel> = .init()
    private let modelFetchEvent: PublishSubject<Void> = .init()
    
    init(viewModel: DailyListViewModel) {
        self.viewModel = viewModel
        self.disposeBag = .init()
        
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

private extension DailyListViewController {
    func configureUI() {
        
    }
    
    func bindViewModel() {

    }
}
