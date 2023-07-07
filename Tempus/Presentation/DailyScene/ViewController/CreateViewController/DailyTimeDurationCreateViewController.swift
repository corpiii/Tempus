//
//  DailyTimeDurationCreateViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/07.
//

import UIKit

import RxSwift
import SnapKit

final class DailyTimeDurationCreateViewController: UIViewController {
    private let backBarButton: UIBarButtonItem = .init(image: UIImage(systemName: "arrow.backward"))
    private let doneBarButton: UIBarButtonItem = .init(systemItem: .done)
    
    // TODO: clockView
    private let dailyClockView: DailyClockView
 
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let startTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let startTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "시작 시간"
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    private let startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.minuteInterval = 5
        
        return picker
    }()
    
    private let repeatCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let repeatCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "반복 횟수"
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    private let repeatCountStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        
        return stepper
    }()
    
    private weak var viewModel: DailyTimeDurationCreateViewModel?
    private let startTimeSubject: PublishSubject<Date> = .init()
    private let repeatCountSubject: PublishSubject<Double> = .init()
    private let doneButtonTapEvent: PublishSubject<Void> = .init()
    private let startEvent: PublishSubject<CompleteAlert> = .init()
    private let disposeBag: DisposeBag = .init()
    
    init(viewModel: DailyTimeDurationCreateViewModel, focusTime: Double, breakTime: Double) {
        self.viewModel = viewModel
        self.dailyClockView = .init(startTime: startTimePicker.date, focusTime: focusTime, breakTime: breakTime)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
        dailyClockView.alertDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - ConfigureUI
private extension DailyTimeDurationCreateViewController {
    func configureUI() {
        self.view.backgroundColor = ColorConstant.backGroundColor
        
        configureNavigationBar()
        configureEntireStackView()
    }
    
    func configureNavigationBar() {
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.title = "새로 만들기"
        
        self.navigationItem.rightBarButtonItem = doneBarButton
        doneBarButton.target = self
        doneBarButton.action = #selector(doneBarButtonTapped)
    }
    
    @objc func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        self.startTimeSubject.onNext(self.startTimePicker.date)
        self.repeatCountSubject.onNext(self.repeatCountStepper.value)
        self.doneButtonTapEvent.onNext(())
    }
    
    func configureEntireStackView() {
        self.view.addSubview(entireStackView)
        
        entireStackView.addArrangedSubview(dailyClockView)
        entireStackView.addArrangedSubview(startTimeStackView)
        entireStackView.addArrangedSubview(repeatCountStackView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        entireStackView.spacing = 10
        entireStackView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea.snp.edges).inset(20)
        }
        
        configureDailyClockView()
        configureStartTimeStackView()
        configureRepeatCountStackView()
    }
    
    func configureDailyClockView() {
        dailyClockView.snp.makeConstraints { make in
            make.width.equalTo(entireStackView.snp.width)
            make.height.equalTo(dailyClockView.snp.width)
        }
    }
    
    func configureStartTimeStackView() {
        startTimeStackView.addArrangedSubview(startTimeLabel)
        startTimeStackView.addArrangedSubview(startTimePicker)
        
        configureStartTimePicker()
    }
    
    func configureStartTimePicker() {
        startTimePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        dailyClockView.setStartTime(sender.date)
    }
    
    func configureRepeatCountStackView() {
        repeatCountStackView.addArrangedSubview(repeatCountLabel)
        repeatCountStackView.addArrangedSubview(repeatCountStepper)
        
        configureRepeatCountStepper()
    }
    
    func configureRepeatCountStepper() {
        repeatCountStepper.minimumValue = 1
        repeatCountStepper.addTarget(self, action: #selector(stepperTapped), for: .touchUpInside)
    }
    
    @objc func stepperTapped(_ sender: UIStepper) {
        dailyClockView.setRepeatCount(Int(sender.value))
    }
}


// MARK: - BindViewModel
private extension DailyTimeDurationCreateViewController {
    func bindViewModel() {
        let input = DailyTimeDurationCreateViewModel.Input(startTime: startTimeSubject,
                                                           repeatCount: repeatCountSubject,
                                                           backButtonTapEvent: backBarButton.rx.tap.asObservable(),
                                                           completeButtonTapEvent: doneButtonTapEvent, startEvent: startEvent)
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else { return }
        
        output.isCreateSuccess
            .subscribe(onNext: { [weak self] isCreateSuccess in
                isCreateSuccess
                ? self?.alertSuccess()
                : self?.alertCreateFail()
            }).disposed(by: disposeBag)
    }
    
    func alertSuccess() {
        let alertController = UIAlertController(title: "생성 완료",
                                      message: "타이머를 바로 시작하시겠습니까?",
                                      preferredStyle: .alert)
        
        let completeWithStartAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            self?.startEvent.onNext(.completeWithStart)
        }
        
        let completeWithoutStartAction = UIAlertAction(title: "아니오", style: .cancel) { [weak self] _ in
            let alertController = UIAlertController(title: "저장",
                                          message: "저장되었습니다",
                                          preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                self?.startEvent.onNext(.completeWithoutStart)
            }
            
            alertController.addAction(confirmAction)
            
            self?.present(alertController, animated: true)
        }
        
        alertController.addAction(completeWithStartAction)
        alertController.addAction(completeWithoutStartAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertCreateFail() {
        let alertController = UIAlertController(title: "실패", message: "생성 실패", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true)
    }
}

extension DailyTimeDurationCreateViewController: AlertRepeatCountOverDelegate {
    func alertRepeatCountOver() {
        repeatCountStepper.value -= 1
        
        let alertController = UIAlertController(title: "실패", message: "횟수가 너무 많아요", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
}
