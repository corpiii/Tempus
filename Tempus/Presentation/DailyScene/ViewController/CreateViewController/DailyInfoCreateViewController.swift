//
//  DailyInfoCreateViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/04.
//

import UIKit

import RxSwift

final class DailyInfoCreateViewController: UIViewController {
    private enum Constant {
        static let outerMargin: CGFloat = 20
    }
    
    private let cancelButton: UIBarButtonItem = .init(systemItem: .cancel)
    private let nextButton: UIBarButtonItem = .init()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = I18NStrings.View.titlePlaceholder
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private let TimeInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let focusTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let focusTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = I18NStrings.View.focusTime
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    private let focusTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .countDownTimer
        
        return datePicker
    }()
    
    private let breakTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let breakTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = I18NStrings.View.breakTime
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    private let breakTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .countDownTimer
        
        return datePicker
    }()
    
    private weak var viewModel: DailyInfoCreateViewModel?
    private let disposeBag: DisposeBag = .init()
    
    private let modelTitleSubject: PublishSubject<String> = .init()
    private let modelFocusTimeSubject: PublishSubject<Date> = .init()
    private let modelBreakTimeSubject: PublishSubject<Date> = .init()
    private let nextButtonTappedEvent: PublishSubject<Void> = .init()
    private let cancelButtonTappedEvent: PublishSubject<Void> = .init()
    
    init(viewModel: DailyInfoCreateViewModel) {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - ConfigureUI
private extension DailyInfoCreateViewController {
    func configureUI() {
        configureNavigationBar()
        configureTitleTextField()
        configureTimeInfoStackView()
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = I18NStrings.NavigationItem.create
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = nextButton
        
        nextButton.title = I18NStrings.NavigationItem.next
        nextButton.target = self
        nextButton.action = #selector(nextBarButtonTapped)
    }
    
    @objc func nextBarButtonTapped(_ sender: UIBarButtonItem) {
        modelTitleSubject.onNext(titleTextField.text ?? "")
        modelFocusTimeSubject.onNext(focusTimePicker.date)
        modelBreakTimeSubject.onNext(breakTimePicker.date)
        nextButtonTappedEvent.onNext(())
    }
    
    func configureTitleTextField() {
        self.view.addSubview(titleTextField)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.titleTextField.snp.makeConstraints { make in
            let inset = Constant.outerMargin
            
            make.leading.equalTo(safeArea.snp.leading).inset(inset)
            make.trailing.equalTo(safeArea.snp.trailing).inset(inset)
            make.top.equalTo(safeArea.snp.top).inset(inset * 2)
            make.height.equalTo(titleTextField.intrinsicContentSize.height)
        }
    }
    
    func configureTimeInfoStackView() {
        let safeArea = self.view.safeAreaLayoutGuide
        let spacing = safeArea.layoutFrame.height * 0.05
        
        self.view.addSubview(TimeInfoStackView)
        self.TimeInfoStackView.addArrangedSubview(focusTimeStackView)
        self.TimeInfoStackView.addArrangedSubview(breakTimeStackView)
        self.TimeInfoStackView.spacing = spacing
        configureFocusTimeStackView()
        configureBreakTimeStackView()
        
        self.TimeInfoStackView.snp.makeConstraints { make in
            let inset = Constant.outerMargin
            
            make.leading.equalTo(safeArea.snp.leading).inset(inset)
            make.trailing.equalTo(safeArea.snp.trailing).inset(inset)
            
            make.top.equalTo(titleTextField.snp.bottom).offset(spacing)
        }
    }
    
    func configureFocusTimeStackView() {
        self.focusTimeStackView.addArrangedSubview(focusTimeLabel)
        self.focusTimeStackView.addArrangedSubview(focusTimePicker)
    }
    
    func configureBreakTimeStackView() {
        self.breakTimeStackView.addArrangedSubview(breakTimeLabel)
        self.breakTimeStackView.addArrangedSubview(breakTimePicker)
    }

}

// MARK: - BindViewModel
private extension DailyInfoCreateViewController {
    func bindViewModel() {
        let input = DailyInfoCreateViewModel.Input(cancelButtonTapEvent: cancelButton.rx.tap.asObservable(),
                                                   nextButtonTapEvent: nextButtonTappedEvent,
                                                   modelTitle: modelTitleSubject,
                                                   modelFocusTime: modelFocusTimeSubject,
                                                   modelBreakTime: modelBreakTimeSubject)
        
        guard let output = viewModel?.transform(input: input, disposeBag: self.disposeBag) else {
            return
        }
        
        output.isFillAllInfo
            .subscribe(onNext: { [weak self] isFillAllInfo in
                if isFillAllInfo == false {
                    self?.alertFailure()
                }
            }).disposed(by: self.disposeBag)
    }
    
    func alertFailure() {
        let alert = UIAlertController(title: I18NStrings.Alert.alertFailTitle,
                                      message: I18NStrings.Alert.dataEmptyCheckMessage,
                                      preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: I18NStrings.Alert.confirmAction, style: .default)
        
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
}
