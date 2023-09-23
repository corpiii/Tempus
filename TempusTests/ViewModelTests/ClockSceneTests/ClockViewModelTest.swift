//
//  ClockViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/25.
//

import XCTest

import RxSwift

final class ClockViewModelTest: XCTestCase {
    var clockViewModel: DefaultClockViewModel!
    var modeStartEvent: PublishSubject<Void>!
    var modeStopEvent: PublishSubject<Void>!
    
    var disposeBag: DisposeBag!
    var clockViewModelInput: DefaultClockViewModel.Input!
    var clockViewModelOutput: DefaultClockViewModel.Output!
    
    var repositoryFake: DataManagerRepositoryFake!
    var coordinatorDummy: ClockCoordinatorDummy!
    
    override func setUpWithError() throws {
        clockViewModel = .init()
        modeStartEvent = .init()
        modeStopEvent = .init()
        
        disposeBag = .init()
        clockViewModelInput = .init(modeStartEvent: modeStartEvent, modeStopEvent: modeStopEvent)
        clockViewModelOutput = clockViewModel.transform(input: clockViewModelInput, disposeBag: disposeBag)
        
        repositoryFake = .init()
        coordinatorDummy = .init()
        
        clockViewModel.coordinator = coordinatorDummy
    }
    
    func test_when_start_usecase_inject_by_BlockCreateViewModel_then_success() {
        // Arrange
        let modeStateExpectation = XCTestExpectation(description: "modeState_test")
        let remainTimeExpectation = XCTestExpectation(description: "remainTime_test")
        let blockModel = BlockModel(id: UUID(), title: "testTitle", blockTime: 12)
        
        clockViewModelOutput.modeStartUseCaseOutput
            .subscribe(onNext: { [weak self] output in
                guard let self else { return }
                print(output)

                output.modeState
                    .subscribe(onNext: { modeState in
                        if modeState == .focusTime {
                            modeStateExpectation.fulfill()
                        }
                    }).disposed(by: self.disposeBag)

                output.remainTime
                    .subscribe(onNext: { time in
                        remainTimeExpectation.fulfill()
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)

        // Act
        clockViewModel.modeStartUseCase = BlockStartUseCase(originModel: blockModel)
        modeStartEvent.onNext(())
        
        // Assert
        wait(for: [modeStateExpectation, remainTimeExpectation], timeout: 30.0)
    }
}
