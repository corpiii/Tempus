//
//  BlockDetailViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/13.
//

import UIKit

import SnapKit
import RxSwift

class BlockDetailViewController: UIViewController {
    private let cancelBarButton: UIBarButtonItem = .init(systemItem: .cancel)
    private let editBarButton: UIBarButtonItem = .init(systemItem: .edit)
    private let startBarButton: UIBarButtonItem = .init(title: "시작")
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let clockView: SplittedClockView = {
        let clockView = SplittedClockView()
        
        return clockView
    }()
    
    var viewModel: BlockDetailViewModel?
    private let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
}

// MARK: - ConfigureUI
private extension BlockDetailViewController {
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        configureNavigationBar()
//        configureTitleLabel()
        configureClockView()
    }
    
    func configureNavigationBar() {
        cancelBarButton.target = self
        cancelBarButton.action = #selector(cancelBarButtonTapped)
        
        editBarButton.target = self
        editBarButton.action = #selector(editBarButtonTapped)
        
        startBarButton.target = self
        startBarButton.action = #selector(startBarButtonTapped)
        
        self.navigationItem.leftBarButtonItem = cancelBarButton
        self.navigationItem.rightBarButtonItems = [startBarButton, editBarButton]
    }
    
    func configureClockView() {
        self.view.addSubview(clockView)
        
        clockView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(clockView.snp.width)
        }
    }
}

// MARK: - ButtonTappedAction
private extension BlockDetailViewController {
    @objc func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func editBarButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func startBarButtonTapped(_ sender: UIBarButtonItem) {
        
    }
}

// MARK: - BindViewModel
private extension BlockDetailViewController {
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        let input = BlockDetailViewModel.Input(startButtonTapEvent: startBarButton.rx.tap.asObservable(),
                                               editButtonTapEvent: editBarButton.rx.tap.asObservable(),
                                               cancelButtonTapEvent: cancelBarButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.originModelSubject
            .subscribe(onNext: { model in
                self.navigationItem.title = model.title
                self.clockView.splitClock(by: "\(model.divideCount)")
            }).disposed(by: disposeBag)
    }
}
