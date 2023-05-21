//
//  ClockViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/19.
//

import UIKit

import RxSwift
import SnapKit

class ClockViewController: UIViewController {
    private let startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("시작", for: .normal)
        
        return button
    }()
    
    private let countDownTimerView: CountDownTimerView = .init()
    
    private let startEvent: PublishSubject<Void> = .init()
    private let stopEvent: PublishSubject<Void> = .init()
    private let disposeBag: DisposeBag = .init()
    var viewModel: ClockViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSelfView()
        configureUI()
        bindViewModel()
    }
}

// MARK: - ConfigureUI
private extension ClockViewController {
    func configureSelfView() {
        self.view.backgroundColor = .systemBackground
    }
    
    func configureUI() {
        // 시계 뷰
        configureTimerView()
        
        // 시작버튼
    }
    
    func configureTimerView() {
        self.view.addSubview(countDownTimerView)
        countDownTimerView.backgroundColor = .systemRed
        
        let safeArea = self.view.safeAreaLayoutGuide
        countDownTimerView.snp.makeConstraints { make in
            make.leading.equalTo(safeArea.snp.leading)
            make.trailing.equalTo(safeArea.snp.trailing)
            
            make.height.equalTo(countDownTimerView.snp.width)
            make.centerY.equalTo(safeArea.snp.centerY)
        }
    }
}

// MARK: - BindViewModel
private extension ClockViewController {
    func bindViewModel() {
        let input = ClockViewModel.Input(modeStartEvent: startEvent,
                                         modeStopEvent: stopEvent)
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {
            #if DEBUG
            print(#file, #function, "viewModel missed")
            #endif
            return
        }
        
        output.modeStartUseCaseOutput
            .subscribe(onNext: { [weak self] output in
                guard let self else { return }
                
                output.remainTime.subscribe(onNext: { time in
                    // 받은 time을 뷰에다 넣기
                }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
}
