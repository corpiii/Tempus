//
//  BlockListViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/09.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class BlockListViewController: UIViewController {
    var viewModel: BlockListViewModel?
    private let disposeBag: DisposeBag = .init()
    
    private let blockCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
}

private extension BlockListViewController {
    func configureUI() {
        // blockCollectionView edge to safeArea
        
    }
    
    func bindViewModel() {
        let input = BlockListViewModel.Input(addButtonEvent: PublishSubject<Void>(),
                                             modelDeleteEvent: PublishSubject<BlockModel>(),
                                             modelFetchEvent: PublishSubject<Void>())
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {
            return
        }
        
        output.blockModelArray
            .subscribe(onNext: { models in
                // collectionView update
            }).disposed(by: disposeBag)
            
        output.isDeleteSuccess
            .subscribe(onNext: { isDeleteSuccess in
                // Alert
            }).disposed(by: disposeBag)
    }
}
