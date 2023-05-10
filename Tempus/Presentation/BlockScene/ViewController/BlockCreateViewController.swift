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
    
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.placeholder = "제목"
        
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
