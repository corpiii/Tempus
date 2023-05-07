//
//  DailyTimeDurationCreateViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/05/02.
//

import XCTest

import RxSwift

final class DailyTimeDurationCreateViewModelTest: XCTestCase {
    var repositoryMock: DataManagerRepositoryMock!
    var disposeBag: DisposeBag!
    var fetchRefreshMock: FetchRefreshMock!
    
    var startTime: PublishSubject<Double>!
    var repeatCount: PublishSubject<Int>!
    var completeButtonTapEvent: PublishSubject<CompleteAlert>!
    
    var dailyTimeCreateViewModel: DailyTimeDurationCreateViewModel!
    var dailyTimeCreateViewModelInput: DailyTimeDurationCreateViewModel.Input!
    var dailyTimeCreateViewModelOutput: DailyTimeDurationCreateViewModel.Output!
    
    override func setUpWithError() throws {
        repositoryMock = .init()
        disposeBag = .init()
        fetchRefreshMock = .init()
        
        startTime = .init()
        repeatCount = .init()
        completeButtonTapEvent = .init()
        
        dailyTimeCreateViewModel = .init(modelTitle: "testTitle",
                                         focusTime: 1.5 * 60 * 60,
                                         breakTime: 5.0 * 60,
                                         repository: repositoryMock,
                                         fetchRefreshDelgate: fetchRefreshMock)
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
        
        // Act
        dailyTimeCreateViewModelOutput.isCreateSuccess
            .subscribe(onNext: { isSuccess in
                resultValue = isSuccess
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        startTime.onNext(testStartTime)
        repeatCount.onNext(testRepeatCount)
        completeButtonTapEvent.onNext(.completeWithoutStart)
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(resultValue)
    }

}
