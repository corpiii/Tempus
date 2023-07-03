//
//  DailyTimeDurationEditViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/19.
//

import UIKit

import RxSwift

class DailyTimeDurationEditViewController: UIViewController {
    private let backBarButton: UIBarButtonItem = .init(image: UIImage(systemName: "arrow.backward"))
    private let doneBarButton: UIBarButtonItem = .init(systemItem: .done)
    
    private let dailyClockView: DailyClockView = .init()
 
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
    
    private weak var viewModel: DailyTimeDurationEditViewModel?
    private let startTimeSubject: PublishSubject<Date> = .init()
    private let repeatCountSubject: PublishSubject<Double> = .init()
    private let doneButtonTapEvent: PublishSubject<Void> = .init()
    private let completeEvent: PublishSubject<Void> = .init()
    private let disposeBag: DisposeBag = .init()
    
    init(viewModel: DailyTimeDurationEditViewModel) {
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
        dailyClockView.alertDelegate = self
    }
}

// MARK: - ConfigureUI
private extension DailyTimeDurationEditViewController {
    func configureUI() {
        self.view.backgroundColor = .init(hex: "#E3F4F4")
        
        configureNavigationBar()
        configureEntireStackView()
    }
    
    func configureNavigationBar() {
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.title = "수정하기"
        
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
private extension DailyTimeDurationEditViewController {
    func bindViewModel() {
        let input = DailyTimeDurationEditViewModel.Input(startTime: startTimeSubject,
                                                         repeatCount: repeatCountSubject,
                                                         backButtonTapEvent: backBarButton.rx.tap.asObservable(),
                                                         doneButtonTapEvent: doneButtonTapEvent,
                                                         completeEvent: completeEvent)
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else { return }
        
        self.startTimePicker.date = output.startTime
        bindOriginModelSubject(output.originModelSubject, disposeBag)
        bindEditSuccess(output.isEditSuccess, disposeBag)
    }
    
    func bindOriginModelSubject(_ originModelSubject: BehaviorSubject<DailyModel>, _ disposeBag: DisposeBag) {
        originModelSubject
            .subscribe(onNext: { [weak self] model in
                self?.repeatCountStepper.value = Double(model.repeatCount)
                self?.dailyClockView.setStats(model.startTime, model.focusTime, model.breakTime, model.repeatCount)
            }).disposed(by: disposeBag)
    }
    
    func bindEditSuccess(_ isEditSuccess: PublishSubject<Bool>, _ disposeBag: DisposeBag) {
        isEditSuccess
            .subscribe(onNext: { [weak self] isEditSuccess in
                guard let self else { return }
                
                isEditSuccess
                ? self.completeEvent.onNext(())
                : self.alertFailure()
                
            }).disposed(by: disposeBag)
    }
    
    func alertFailure() {
        let alert = UIAlertController(title: "실패",
                                      message: "수정이 실패했습니다. \n 빈값이 있는지 확인해주세요.",
                                      preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
}

extension DailyTimeDurationEditViewController: AlertRepeatCountOverDelegate {
    func alertRepeatCountOver() {
        repeatCountStepper.value -= 1
        
        let alertController = UIAlertController(title: "실패", message: "횟수가 너무 많아요", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
}
