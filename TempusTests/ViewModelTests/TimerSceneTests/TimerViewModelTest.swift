//
//  TimerViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/05/07.
//

import XCTest

import RxSwift

final class TimerViewModelTest: XCTestCase {
    var timerViewModel: TimerViewModel!
    var coordinatorDummy: TimerCoordinatorDummy!
    var disposeBag: DisposeBag!
    
    var modelWasteTime: PublishSubject<Date>!
    var startButtonTapEvent: PublishSubject<Void>!
    
    var defaultTimerViewModelInput: DefaultTimerViewModel.Input!
    
    override func setUpWithError() throws {
        timerViewModel = DefaultTimerViewModel()
        coordinatorDummy = .init()
        disposeBag = .init()
        modelWasteTime = .init()
        startButtonTapEvent = .init()
        
        timerViewModel.coordinator = coordinatorDummy
        defaultTimerViewModelInput = .init(modelWasteTime: modelWasteTime,
                                           startButtonTapEvent: startButtonTapEvent)
    }
    
    func test_start_is_success() {
        // Arrange
        let startToday = Calendar(identifier: .gregorian).startOfDay(for: Date())
        let testWasteTime = Date(timeInterval: 3 * 60 * 60, since: startToday)
        
        // Act
        timerViewModel.bind(input: defaultTimerViewModelInput, disposeBag: disposeBag)
        
        modelWasteTime.onNext(testWasteTime)
        startButtonTapEvent.onNext(())
        
        // Assert
        XCTAssertEqual(timerViewModel.wasteTime, 3 * 60 * 60)
    }
}
