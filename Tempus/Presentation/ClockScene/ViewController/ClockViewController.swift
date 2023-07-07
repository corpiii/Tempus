//
//  ClockViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/19.
//

import UIKit

import RxSwift
import SnapKit
import LGButton

class ClockViewController: UIViewController {
    private enum Constant {
        static let startButtonColor: UIColor = .init(red: 49 / 255.0,
                                                     green: 130 / 255.0,
                                                     blue: 222 / 255.0,
                                                     alpha: 87 / 100.0)
        static let timerViewWidthMultipleBySafeAreaWidth: Double = 0.8
    }
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
        
    private let countDownTimerView: CountDownTimerView = .init()
    
    private let startButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let startButton: LGButton = {
        let button = LGButton()
        button.leftImageColor = .white
        button.leftImageSrc = .init(systemName: "play.fill")
        button.bgColor = Constant.startButtonColor
        button.cornerRadius = 10
        
        return button
    }()
    
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
    }
    
    private func makeWidthDividerView() -> UIView {
        let emptyView = UIView()
        
        emptyView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(1)
        }
        
        return emptyView
    }
}

// MARK: - ConfigureUI
private extension ClockViewController {
    func configureSelfView() {
        self.view.backgroundColor = ColorConstant.fourthColor
    }
    
    func configureUI() {
        configureEntireStackView()
        configureTimerView()
        configureStartButtonStackView()
    }
    
    func configureEntireStackView() {
        self.view.addSubview(entireStackView)
        
        entireStackView.addArrangedSubview(countDownTimerView)
        entireStackView.addArrangedSubview(startButtonStackView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        entireStackView.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea.snp.centerX)
            make.centerY.equalTo(safeArea.snp.centerY)
        }
        
        let timerViewHeight = safeArea.layoutFrame.width * Constant.timerViewWidthMultipleBySafeAreaWidth
        entireStackView.spacing = timerViewHeight * 0.2
    }
    
    func configureTimerView() {
        let safeArea = self.view.safeAreaLayoutGuide
        countDownTimerView.snp.makeConstraints { make in
            make.width.equalTo(safeArea.snp.width).multipliedBy(Constant.timerViewWidthMultipleBySafeAreaWidth)
            make.height.equalTo(countDownTimerView.snp.width)
        }
    }
    
    func configureStartButtonStackView() {
        let leftDivideView = makeWidthDividerView()
        let rightDivideView = makeWidthDividerView()
        
        startButtonStackView.addArrangedSubview(leftDivideView)
        startButtonStackView.addArrangedSubview(startButton)
        startButtonStackView.addArrangedSubview(rightDivideView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        leftDivideView.snp.makeConstraints { make in
            let totalWidth = safeArea.layoutFrame.width * Constant.timerViewWidthMultipleBySafeAreaWidth
            let startButtonWidth = safeArea.layoutFrame.width * 0.25
            let width = (totalWidth - startButtonWidth) / 2
            
            make.width.equalTo(width)
        }
        
        configureStartButton()
    }
    
    func configureStartButton() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        startButton.snp.makeConstraints { make in
            let startButtonWidth = safeArea.layoutFrame.width * 0.25
            make.width.equalTo(startButtonWidth)
            make.height.equalTo(startButtonWidth * 0.5)
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
        setStartButtonState(isSelected: startButton.isSelected)
        UserDefaults.standard.set(startButton.isSelected, forKey: "isModeStarted")
    }
    
    func setStartButtonState(isSelected: Bool) {
        if isSelected {
            startButton.leftImageSrc = .init(systemName: "stop.fill")
        } else {
            startButton.leftImageSrc = .init(systemName: "play.fill")
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
                
                self.startButton.isSelected = true
                self.setStartButtonState(isSelected: true)
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
