//
//  DailyTimeDurationEditViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/05/07.
//

import XCTest

import RxSwift

final class DailyTimeDurationEditViewModelTest: XCTestCase {
    var repositoryMock: DataManagerRepositoryMock!
    var disposeBag: DisposeBag!
    
    var fetchRefreshDelegate: FetchRefreshMock!
    var editReflectDelegate: EditReflectMock!
    
    var originModel: DailyModel!
    
    var dailyTimeDurationEditViewModel: DailyTimeDurationEditViewModel!
    
    var startTime: PublishSubject<Double>!
    var repeatCount: PublishSubject<Int>!
    var completeButtonTapEvent: PublishSubject<Void>!
    
    var input: DailyTimeDurationEditViewModel.Input!
    var output: DailyTimeDurationEditViewModel.Output!
    
    override func setUpWithError() throws {
        repositoryMock = .init()
        disposeBag = .init()
        
        fetchRefreshDelegate = .init()
        editReflectDelegate = .init()
        
        originModel = .init(id: UUID(),
                            title: "testTitle",
                            startTime: 13.0 * 60 * 60,
                            repeatCount: 4,
                            focusTime: 1.5 * 60 * 60,
                            breakTime: 0.5 * 60 * 60)
        
        dailyTimeDurationEditViewModel = .init(originModel: originModel,
                                               repository: repositoryMock,
                                               fetchRefreshDelegate: fetchRefreshDelegate,
                                               editReflectDelegate: editReflectDelegate)
        
        startTime = .init()
        repeatCount = .init()
        completeButtonTapEvent = .init()
        
        input = .init(startTime: startTime,
                      repeatCount: repeatCount,
                      backButtonTapEvent: PublishSubject<Void>(),
                      completeButtonTapEvent: completeButtonTapEvent)
        output = dailyTimeDurationEditViewModel.transform(input: input, disposeBag: disposeBag)
    }
    
    func test_edit_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "edit_is_success")
        let testStartTime = 15.0 * 60 * 60
        let testRepeatCount = 3
        var result = false
        
        // Act
        output.isEditSuccess
            .subscribe(onNext: { isSuccess in
                result = isSuccess
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        startTime.onNext(testStartTime)
        repeatCount.onNext(testRepeatCount)
        completeButtonTapEvent.onNext(())
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(result)
        
        let dailyModel = repositoryMock.dailyModel
        XCTAssertEqual(dailyModel?.startTime, testStartTime)
        XCTAssertEqual(dailyModel?.repeatCount, testRepeatCount)
    }

}
