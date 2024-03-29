//
//  BlockCreateViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/10.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class BlockCreateViewController: UIViewController {
    private enum Constant {
        static let outerMagins: CGFloat = 20
        static let entireStackSpacing: CGFloat = 40
        static let divideCountStackSpacing: CGFloat = 40
        static let pickerViewWidth: CGFloat = 100
        static let blockTimeCandidates: [String] = [I18NStrings.View.select, "3", "4", "6", "8", "12"]
    }
    
    private let cancelButton: UIBarButtonItem = .init(systemItem: .cancel)
    private let completeButton: UIBarButtonItem = .init(systemItem: .done)
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let divideCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Constant.divideCountStackSpacing
        
        return stackView
    }()
    
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.placeholder = I18NStrings.View.titlePlaceholder
        titleTextField.borderStyle = .roundedRect
        
        return titleTextField
    }()
    
    private let blockClockView: BlockClockView = {
        let clockView = BlockClockView()
        
        return clockView
    }()
    
    private let timeIntervalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = I18NStrings.View.timeInterval
        
        return label
    }()
    
    private let divideCountPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()
    
    private weak var viewModel: BlockCreateViewModel?
    private let disposeBag: DisposeBag = .init()
    private let textFieldSubject: PublishSubject<String> = .init()
    private let timeIntervalSubject: PublishSubject<Int> = .init()
    private let completeEvent: PublishSubject<Void> = .init()
    private let startEvent: PublishSubject<CompleteAlert> = .init()
    private let disappearEvent: PublishSubject<Void> = .init()
    
    init(viewModel: BlockCreateViewModel) {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func makeHeightDividerView() -> UIView {
        let emptyView = UIView()
        
        emptyView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(1)
        }
        
        return emptyView
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
private extension BlockCreateViewController {
    func configureUI() {
        self.view.backgroundColor = ColorConstant.backGroundColor
        configureNavigationBar()
        configureEntireStackView()
        configureDivideCountStackView()
        
        configureTitleTextField()
        configureBlockClockView()
        configureDivideCountPickerView()
    }
    
    func configureNavigationBar() {
        self.navigationItem.leftBarButtonItem = cancelButton
        
        self.navigationItem.title = I18NStrings.NavigationItem.create
        self.navigationItem.rightBarButtonItem = completeButton
        completeButton.target = self
        completeButton.action = #selector(completeButtonTapped)
    }
    
    @objc func completeButtonTapped(_ sender: UIBarButtonItem) {
        let selectRow = self.divideCountPickerView.selectedRow(inComponent: 0)
        let timeInterval = Int(Constant.blockTimeCandidates[selectRow]) ?? -1
        
        textFieldSubject.onNext(titleTextField.text ?? "")
        timeIntervalSubject.onNext(timeInterval)
        completeEvent.onNext(())
    }
    
    func alertSuccess() {
        let alertController = UIAlertController(title: I18NStrings.Alert.successCreateTitle,
                                                message: I18NStrings.Alert.timerStartNowMessage,
                                                preferredStyle: .alert)
        
        let completeWithStartAction = UIAlertAction(title: I18NStrings.Alert.YesAction, style: .default) { [weak self] _ in
            self?.startEvent.onNext(.completeWithStart)
        }
        let completeWithoutStartAction = UIAlertAction(title: I18NStrings.Alert.NoAction, style: .cancel) { [weak self] _ in
            let alertController = UIAlertController(title: I18NStrings.Alert.storeAlertTitle,
                                                    message: I18NStrings.Alert.storeAlertMessage,
                                                    preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: I18NStrings.Alert.confirmAction, style: .default) { [weak self] _ in
                self?.startEvent.onNext(.completeWithoutStart)
            }
            
            alertController.addAction(confirmAction)
            
            self?.present(alertController, animated: true)
        }
        
        alertController.addAction(completeWithStartAction)
        alertController.addAction(completeWithoutStartAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertFailure() {
        let alert = UIAlertController(title: I18NStrings.Alert.alertFailTitle,
                                      message: I18NStrings.Alert.dataEmptyCheckMessage,
                                      preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: I18NStrings.Alert.confirmAction, style: .default)
        
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
    
    func configureEntireStackView() {
        let safeArea = self.view.safeAreaLayoutGuide
        let emptyView = makeHeightDividerView()
        
        self.view.addSubview(entireStackView)
        entireStackView.addArrangedSubview(titleTextField)
        entireStackView.addArrangedSubview(blockClockView)
        entireStackView.addArrangedSubview(divideCountStackView)
        entireStackView.addArrangedSubview(emptyView)
        
        entireStackView.spacing = Constant.entireStackSpacing
        
        entireStackView.snp.makeConstraints { make in
            make.leading.equalTo(safeArea.snp.leading).offset(Constant.outerMagins)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-Constant.outerMagins)
            make.top.equalTo(safeArea.snp.top).offset(Constant.outerMagins)
            make.bottom.equalTo(safeArea.snp.bottom).offset(-Constant.outerMagins)
        }
    }
    
    func configureDivideCountStackView() {
        let leftDividerView = makeWidthDividerView()
        let rightDividerView = makeWidthDividerView()
        
        divideCountStackView.addArrangedSubview(leftDividerView)
        divideCountStackView.addArrangedSubview(timeIntervalLabel)
        divideCountStackView.addArrangedSubview(divideCountPickerView)
        divideCountStackView.addArrangedSubview(rightDividerView)
        
        let stackWidthSize = self.view.frame.width - Constant.outerMagins * 2
        let allSpacing = 3 * Constant.divideCountStackSpacing
        let mainSize = Constant.pickerViewWidth + timeIntervalLabel.intrinsicContentSize.width + allSpacing
        let targetSize = (stackWidthSize - mainSize) / 2
        
        leftDividerView.snp.remakeConstraints { make in
            make.width.equalTo(targetSize)
        }
    }
    
    func configureTitleTextField() {
        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(titleTextField.intrinsicContentSize.height)
        }
    }
    
    func configureBlockClockView() {
        blockClockView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(blockClockView.snp.width)
        }
    }
    
    func configureDivideCountPickerView() {
        divideCountPickerView.dataSource = self
        divideCountPickerView.delegate = self
        
        divideCountPickerView.snp.makeConstraints { make in
            make.width.equalTo(Constant.pickerViewWidth)
        }
    }
}

// MARK: - BindViewModel
private extension BlockCreateViewController {
    func bindViewModel() {
        typealias Input = DefaultBlockCreateViewModel.Input
        typealias Output = DefaultBlockCreateViewModel.Output
        
        let input = Input(modelTitle: textFieldSubject,
                          modelBlockTime: timeIntervalSubject,
                          completeButtonTapEvent: completeEvent,
                          cancelButtonTapEvent: cancelButton.rx.tap.asObservable(),
                          startEvent: startEvent)
        
        guard let output: Output = viewModel?.transform(input: input, disposeBag: disposeBag) else {
            return
        }
        
        bindCreateSuccess(output.isCreateSuccess)
    }
    
    func bindCreateSuccess(_ isCreateSuccess: PublishRelay<Bool>) {
        isCreateSuccess
            .subscribe(onNext: { [weak self] isCreateSuccess in
                guard let self else { return }
                isCreateSuccess
                ? self.alertSuccess()
                : self.alertFailure()
            }).disposed(by: disposeBag)
    }
}

extension BlockCreateViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return divideCountStackView.bounds.height * 0.5
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        blockClockView.splitClock(by: Constant.blockTimeCandidates[row])
    }
}

extension BlockCreateViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constant.blockTimeCandidates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constant.blockTimeCandidates[row]
    }
}
