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

class BlockCreateViewController: UIViewController {
    private let completeButton: UIBarButtonItem = .init(systemItem: .done)
    private let completeEvent: PublishSubject<CompleteAlert> = .init()
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.placeholder = "제목"
        titleTextField.borderStyle = .roundedRect
        
        return titleTextField
    }()
    
    private let splittedClockView: SplittedClockView = {
        let clockView = SplittedClockView()
        
        return clockView
    }()
    
    private let divideCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "단위 시간"
        
        return label
    }()
    
    private let divideCountPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()
    
    var viewModel: BlockCreateViewModel?
    private let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
}

// MARK: - ConfigureUI
private extension BlockCreateViewController {
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureEntireStackView()
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "새로 만들기"
        self.navigationItem.rightBarButtonItem = completeButton
        completeButton.target = self
        completeButton.action = #selector(completeButtonTapped)
    }
    
    @objc func completeButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "생성 완료",
                                      message: "타이머를 바로 시작하시겠습니까?",
                                      preferredStyle: .alert)
        
        let completeWithStartAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            self?.completeEvent.onNext(.completeWithStart)
        }
        let completeWithoutStartAction = UIAlertAction(title: "아니오", style: .cancel) { [weak self] _ in
            let alert = UIAlertController(title: "저장",
                                          message: "저장되었습니다",
                                          preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                self?.completeEvent.onNext(.completeWithoutStart)
            }
            
            alert.addAction(confirmAction)
            
            self?.present(alert, animated: true)
        }
        
        alert.addAction(completeWithStartAction)
        alert.addAction(completeWithoutStartAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureEntireStackView() {
        let safeArea = self.view.safeAreaLayoutGuide

        self.view.addSubview(entireStackView)
        entireStackView.addArrangedSubview(titleTextField)
        
        entireStackView.backgroundColor = .systemRed
        
        entireStackView.snp.makeConstraints { make in
            make.leading.equalTo(safeArea.snp.leading).offset(20)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-20)
            make.top.equalTo(safeArea.snp.top).offset(20)
            make.bottom.equalTo(safeArea.snp.bottom).offset(-20)
        }
    }
}

// MARK: - BindViewModel
private extension BlockCreateViewController {
    func bindViewModel() {
        let input = BlockCreateViewModel.Input(completeButtonTapEvent: completeEvent,
                                               modelTitle: titleTextField.rx.text.orEmpty.asObservable(),
                                               modelDivideCount: divideCountPickerView.rx.itemSelected.map { $0.row })
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {
            return
        }
    }
}
