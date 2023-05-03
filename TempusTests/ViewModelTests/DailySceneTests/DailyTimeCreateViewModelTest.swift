//
//  DailyTimeCreateViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/05/02.
//

import XCTest

import RxSwift

final class DailyTimeCreateViewModelTest: XCTestCase {
    var repositoryMock: DataManagerRepositoryMock!
    var disposeBag: DisposeBag!
    var dailyListViewModel: DailyListViewModel!
    var dailyListViewModelInput: DailyListViewModel.Input!
    var dailyListViewModelOutput: DailyListViewModel.Output!
    
    var startTime: PublishSubject<Double>!
    var repeatCount: PublishSubject<Int>!
    var completeButtonTapEvent: PublishSubject<CompleteAlert>!
    
    var dailyTimeCreateViewModel: DailyTimeCreateViewModel!
    var dailyTimeCreateViewModelInput: DailyTimeCreateViewModel.Input!
    var dailyTimeCreateViewModelOutput: DailyTimeCreateViewModel.Output!
    
    override func setUpWithError() throws {
        repositoryMock = .init()
        disposeBag = .init()
        dailyListViewModel = .init(repository: repositoryMock)
        dailyListViewModelInput = .init(addButtonEvent: PublishSubject<Void>(),
                                        modelDeleteEvent: PublishSubject<DailyModel>(),
                                        modelFetchEvent: PublishSubject<Void>())
        dailyListViewModelOutput = dailyListViewModel.transform(input: dailyListViewModelInput, disposeBag: disposeBag)
                
        startTime = .init()
        repeatCount = .init()
        completeButtonTapEvent = .init()
        
        dailyTimeCreateViewModel = .init(modelTitle: "testTitle",
                                         focusTime: 1.5 * 60 * 60,
                                         breakTime: 5.0 * 60,
                                         repository: repositoryMock,
                                         fetchRefreshDelgate: dailyListViewModel)
        dailyTimeCreateViewModelInput = .init(startTime: startTime,
                                              repeatCount: repeatCount,
                                              backButtonTapEvent: PublishSubject<Void>(),
                                              completeButtonTapEvent: completeButtonTapEvent)
        dailyTimeCreateViewModelOutput = dailyTimeCreateViewModel.transform(input: dailyTimeCreateViewModelInput,
                                                                            disposeBag: disposeBag)
    }

    func test_create_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "create_is_success")
        let testStartTime = 12.0 * 60 * 60
        let testRepeatCount = 4
        var resultValue = false
        
        dailyTimeCreateViewModelOutput.isCreateSuccess
            .subscribe(onNext: { isSuccess in
                resultValue = isSuccess
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        // Act
        startTime.onNext(testStartTime)
        repeatCount.onNext(testRepeatCount)
        completeButtonTapEvent.onNext(.completeWithoutStart)
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(resultValue)
    }

}
