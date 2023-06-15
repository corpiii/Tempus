//
//  BlockDetailViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/13.
//

import UIKit

import RxSwift
import SnapKit

final class BlockDetailViewController: UIViewController {
    private let editBarButton: UIBarButtonItem = .init(systemItem: .edit)
    private let startBarButton: UIBarButtonItem = .init(title: "시작")
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let clockView: BlockClockView = {
        let clockView = BlockClockView()
        
        return clockView
    }()
    
    private weak var viewModel: BlockDetailViewModel?
    private let disappearEvent: PublishSubject<Void> = .init()
    private let disposeBag: DisposeBag = .init()
    
    init(viewModel: BlockDetailViewModel) {
        self.viewModel = viewModel
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disappearEvent.onNext(())
    }
}

// MARK: - ConfigureUI
private extension BlockDetailViewController {
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureEntireStackView()
        configureClockView()
    }
    
    func configureEntireStackView() {
        self.view.addSubview(entireStackView)
        
        let safeArea = self.view.safeAreaLayoutGuide.snp
        
        entireStackView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top)
            make.leading.equalTo(safeArea.leading)
            make.trailing.equalTo(safeArea.trailing)
            make.bottom.equalTo(safeArea.bottom)
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItems = [startBarButton, editBarButton]
    }
    
    func configureClockView() {
        self.view.addSubview(clockView)
        
        let safeArea = self.view.safeAreaLayoutGuide.snp
        
        clockView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top).offset(self.view.frame.height * 0.1)
            make.centerX.equalTo(safeArea.centerX)
            
            make.width.equalTo(safeArea.width).offset(-20)
            make.height.equalTo(clockView.snp.width)
        }
        clockView.layoutIfNeeded()
    }
}

// MARK: - BindViewModel
private extension BlockDetailViewController {
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        let input = BlockDetailViewModel.Input(startButtonTapEvent: startBarButton.rx.tap.asObservable(),
                                               editButtonTapEvent: editBarButton.rx.tap.asObservable(),
                                               disappearEvent: disappearEvent)
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.originModelSubject
            .subscribe(onNext: { model in
                DispatchQueue.main.async {
                    self.navigationItem.title = model.title
                    self.clockView.splitClock(by: "\(model.blockTime)")
                }
            }).disposed(by: disposeBag)
        
    }
}
