//
//  DailyTimeDurationCreateViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/05/02.
//

import XCTest

import RxSwift

final class DailyTimeDurationCreateViewModelTest: XCTestCase {
    var repositoryFake: DataManagerRepositoryFake!
    var disposeBag: DisposeBag!
    var fetchRefreshDummy: FetchRefreshDummy!
    
    var startTime: PublishSubject<Date>!
    var repeatCount: PublishSubject<Double>!
    var completeButtonTapEvent: PublishSubject<Void>!
    var startEvent: PublishSubject<CompleteAlert>!
    
    var dailyTimeCreateViewModel: DailyTimeDurationCreateViewModel!
    var dailyTimeCreateViewModelInput: DefaultDailyTimeDurationCreateViewModel.Input!
    var dailyTimeCreateViewModelOutput: DefaultDailyTimeDurationCreateViewModel.Output!
    
    override func setUpWithError() throws {
        repositoryFake = .init()
        disposeBag = .init()
        fetchRefreshDummy = .init()
        
        startTime = .init()
        repeatCount = .init()
        completeButtonTapEvent = .init()
        startEvent = .init()
        
        dailyTimeCreateViewModel = DefaultDailyTimeDurationCreateViewModel(modelTitle: "testTitle",
                                                                           focusTime: 1.5 * 60 * 60,
                                                                           breakTime: 5.0 * 60,
                                                                           repository: repositoryFake,
                                                                           fetchRefreshDelgate: fetchRefreshDummy)
        dailyTimeCreateViewModelInput = .init(startTime: startTime,
                                              repeatCount: repeatCount,
                                              backButtonTapEvent: PublishSubject<Void>(),
                                              completeButtonTapEvent: completeButtonTapEvent,
                                              startEvent: startEvent)
        dailyTimeCreateViewModelOutput = dailyTimeCreateViewModel.transform(input: dailyTimeCreateViewModelInput,
                                                                            disposeBag: disposeBag)
    }

    func test_create_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "create_is_success")
        let startToday = Calendar(identifier: .gregorian).startOfDay(for: Date())
        let testStartTime = Date(timeInterval: 12 * 60 * 60, since: startToday)
        let testRepeatCount = Double(4)
        var resultValue = false
        
        // Act
        dailyTimeCreateViewModelOutput.isCreateSuccess
            .subscribe(onNext: { isSuccess in
                resultValue = isSuccess
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        startTime.onNext(testStartTime)
        repeatCount.onNext(testRepeatCount)
        completeButtonTapEvent.onNext(())
        startEvent.onNext(.completeWithoutStart)
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(resultValue)
    }

}
