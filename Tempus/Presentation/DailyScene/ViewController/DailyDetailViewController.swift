//
//  DailyDetailViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/17.
//

import UIKit

import RxSwift

final class DailyDetailViewController: UIViewController {
    private let backBarButton: UIBarButtonItem = .init(image: UIImage(systemName: "arrow.backward"))
    private let editBarButton: UIBarButtonItem = .init(systemItem: .edit)
    private let startBarButton: UIBarButtonItem = .init(title: I18NStrings.NavigationItem.start)
    
    private let dailyClockView: DailyClockView = .init()
    private weak var viewModel: DailyDetailViewModel?
    private let disposeBag: DisposeBag = .init()
    
    init(viewModel: DailyDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorConstant.backGroundColor
        
        configureUI()
        bindViewModel()
    }
}

// MARK: - ConfigureUI
private extension DailyDetailViewController {
    func configureUI() {
        configureNavigationBar()
        configureClockView()
    }
    
    func configureNavigationBar() {
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.rightBarButtonItems = [startBarButton, editBarButton]
    }
    
    func configureClockView() {
        self.view.addSubview(dailyClockView)
        
        let safeArea = self.view.safeAreaLayoutGuide.snp
        
        dailyClockView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top).offset(self.view.frame.height * 0.1)
            make.centerX.equalTo(safeArea.centerX)
            
            make.width.equalTo(safeArea.width).offset(-20)
            make.height.equalTo(dailyClockView.snp.width)
        }
    }
}


// MARK: - BindViewModel
private extension DailyDetailViewController {
    func bindViewModel() {
        typealias Input = DefaultDailyDetailViewModel.Input
        typealias Output = DefaultDailyDetailViewModel.Output
        
        let input = Input(startButtonTapEvent: startBarButton.rx.tap.asObservable(),
                                               editButtonTapEvent: editBarButton.rx.tap.asObservable(),
                                               backButtonTapEvent: backBarButton.rx.tap.asObservable())
        
        guard let output: Output = viewModel?.transform(input: input, disposeBag: disposeBag) else {
            return
        }
        
        bindOriginModelSubject(output.originModelSubject, disposeBag)
    }
    
    func bindOriginModelSubject(_ modelSubject: BehaviorSubject<DailyModel>, _ disposeBag: DisposeBag) {
        modelSubject
            .subscribe(onNext: { [weak self] model in
                self?.navigationItem.title = model.title
                self?.dailyClockView.setStats(model.startTime,
                                              model.focusTime,
                                              model.breakTime,
                                              model.repeatCount)
            }).disposed(by: disposeBag)
    }
}
