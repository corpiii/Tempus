//
//  ClockViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/19.
//

import UIKit

import SSBouncyButton
import RxSwift
import SnapKit

class ClockViewController: UIViewController {
    private let startButton: SSBouncyButton = {
        let button = SSBouncyButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("시작", for: .normal)
        button.setTitle("중지", for: .selected)
        button.tintColor = .systemBlue
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .none)
        
        return button
    }()
    
    private let countDownTimerView: CountDownTimerView = .init()
    
    private let startEvent: PublishSubject<Void> = .init()
    private let stopEvent: PublishSubject<Void> = .init()
    private let disposeBag: DisposeBag = .init()
    private weak var viewModel: ClockViewModel?
    
    init(viewModel: ClockViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSelfView()
        configureUI()
        bindViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(observeModel), name: NSNotification.Name("modelNotification"), object: nil)
    }
    
    @objc private func observeModel(_ sender: Notification) {
        if let object = sender.object as? Data {
            let decoder = JSONDecoder()
            
            if let dailyModel = try? decoder.decode(DailyModel.self, from: object) {
                let dailyStartUseCase = DailyStartUseCase(originModel: dailyModel)
                viewModel?.modeStartUseCase = dailyStartUseCase
            } else if let blockModel = try? decoder.decode(BlockModel.self, from: object) {
                let blockStartUseCase = BlockStartUseCase(originModel: blockModel)
                viewModel?.modeStartUseCase = blockStartUseCase
            } else if let timerModel = try? decoder.decode(TimerModel.self, from: object) {
                let timerStartUseCase = TimerStartUseCase(originModel: timerModel)
                viewModel?.modeStartUseCase = timerStartUseCase
            }
        }
    }
}

// MARK: - ConfigureUI
private extension ClockViewController {
    func configureSelfView() {
        self.view.backgroundColor = .systemBackground
    }
    
    func configureUI() {
        configureTimerView()
        configureStartButton()
    }
    
    func configureTimerView() {
        self.view.addSubview(countDownTimerView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        countDownTimerView.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea.snp.centerX)
            make.width.equalTo(safeArea.snp.width).multipliedBy(0.8)
            
            make.height.equalTo(countDownTimerView.snp.width)
            
            let height = safeArea.layoutFrame.height
            make.top.equalTo(safeArea.snp.top).offset(height * 0.1)
        }
    }
    
    func configureStartButton() {
        self.view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        startButton.snp.makeConstraints { make in
            let timerViewHeight = safeArea.layoutFrame.width * 0.8
            make.top.equalTo(countDownTimerView.snp.bottom).offset(timerViewHeight * 0.2)
            
            make.centerX.equalTo(safeArea.snp.centerX)
            
            let startButtonWidth = safeArea.layoutFrame.width * 0.2
            make.width.equalTo(startButtonWidth)
            make.height.equalTo(startButtonWidth / 2)
        }
    }
    
    @objc func startButtonTapped() {
        guard (viewModel?.modeStartUseCase) != nil else {
            alertUseCaseEmpty()
            return
        }
        
        if startButton.isSelected {
            stopEvent.onNext(())
            countDownTimerView.setEmpty()
        } else {
            startEvent.onNext(())
        }
        
        startButton.isSelected = !startButton.isSelected
        UserDefaults.standard.set(startButton.isSelected, forKey: "isModeStarted")
    }
}

// MARK: - BindViewModel
private extension ClockViewController {
    func bindViewModel() {
        let input = ClockViewModel.Input(modeStartEvent: startEvent,
                                         modeStopEvent: stopEvent)
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {
            #if DEBUG
            print(#file, #function, #line, "viewModel missed")
            #endif
            return
        }
        
        output.modeStartUseCaseOutput
            .subscribe(onNext: { [weak self] output in
                guard let self else { return }
                
                output.remainTime.subscribe(onNext: { time in
                    #if DEBUG
                    print(time, #file, #line)
                    #endif
                    
                    self.countDownTimerView.setTime(time)
                }).disposed(by: self.disposeBag)
                
                output.entireRunningTime.subscribe(onNext: { runningTime in
                    self.countDownTimerView.setRunningTime(runningTime)
                }).disposed(by: self.disposeBag)
                
                self.startEvent.onNext(())
                self.startButton.isSelected = true
            }).disposed(by: disposeBag)
    }
}

// MARK: - alert
private extension ClockViewController {
    func alertUseCaseEmpty() {
        let alertController = UIAlertController(title: "알림", message: "모드가 비었습니다", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true)
    }
}
