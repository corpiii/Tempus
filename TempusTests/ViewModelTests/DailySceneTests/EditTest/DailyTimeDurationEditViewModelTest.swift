//
//  DailyTimeDurationEditViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/05/07.
//

import XCTest

import RxSwift

final class DailyTimeDurationEditViewModelTest: XCTestCase {
    var repositoryFake: DataManagerRepositoryFake!
    var disposeBag: DisposeBag!
    
    var fetchRefreshDelegate: FetchRefreshDummy!
    var editReflectDelegate: EditReflectDummy!
    
    var originModel: DailyModel!
    
    var dailyTimeDurationEditViewModel: DailyTimeDurationEditViewModel!
    
    var startTime: PublishSubject<Date>!
    var repeatCount: PublishSubject<Double>!
    var backButtonTapEvent: PublishSubject<Void>!
    var doneButtonTapEvent: PublishSubject<Void>!
    var completeButtonTapEvent: PublishSubject<Void>!
    
    var dailyTimeDurationEditViewModelInput: DefaultDailyTimeDurationEditViewModel.Input!
    var dailyTimeDurationEditViewModelOutput: DefaultDailyTimeDurationEditViewModel.Output!
    
    override func setUpWithError() throws {
        repositoryFake = .init()
        disposeBag = .init()
        
        fetchRefreshDelegate = .init()
        editReflectDelegate = .init()
        
        originModel = .init(id: UUID(),
                            title: "testTitle",
                            startTime: 13.0 * 60 * 60,
                            repeatCount: 4,
                            focusTime: 1.5 * 60 * 60,
                            breakTime: 0.5 * 60 * 60)
        
        dailyTimeDurationEditViewModel = DefaultDailyTimeDurationEditViewModel(originModel: originModel,
                                                                               repository: repositoryFake,
                                                                               fetchRefreshDelegate: fetchRefreshDelegate,
                                                                               editReflectDelegate: editReflectDelegate)
        
        startTime = .init()
        repeatCount = .init()
        backButtonTapEvent = .init()
        doneButtonTapEvent = .init()
        completeButtonTapEvent = .init()
        
        dailyTimeDurationEditViewModelInput = .init(startTime: startTime,
                                                    repeatCount: repeatCount,
                                                    backButtonTapEvent: backButtonTapEvent,
                                                    doneButtonTapEvent: doneButtonTapEvent,
                                                    completeEvent: completeButtonTapEvent)
        dailyTimeDurationEditViewModelOutput = dailyTimeDurationEditViewModel.transform(input: dailyTimeDurationEditViewModelInput,
                                                                                        disposeBag: disposeBag)
    }
    
    func test_edit_is_success() {
        // Arrange
        
        let startToday = Calendar(identifier: .gregorian).startOfDay(for: Date())
        
        let expectation = XCTestExpectation(description: "edit_is_success")
        let testStartTime = Date(timeInterval: 15 * 60 * 60, since: startToday)
        let testRepeatCount = Double(3)
        var result = false
        
        // Act
        dailyTimeDurationEditViewModelOutput.isEditSuccess
            .subscribe(onNext: { isSuccess in
                result = isSuccess
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        startTime.onNext(testStartTime)
        repeatCount.onNext(testRepeatCount)
        doneButtonTapEvent.onNext(())
        completeButtonTapEvent.onNext(())
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(result)
    }

}
