//
//  BlockEditUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/03/31.
//

import XCTest

final class BlockEditUseCaseTest: XCTestCase {
    var blockCreateUseCase: BlockCreateUseCase!
    var blockEditUseCase: BlockEditUseCase!
    var coreDataRepositoryMock: DataManagerRepositoryMock!
    
    override func setUpWithError() throws {
        coreDataRepositoryMock = DataManagerRepositoryMock()
        blockCreateUseCase = BlockCreateUseCase(repository: coreDataRepositoryMock)
        blockEditUseCase = BlockEditUseCase(repository: coreDataRepositoryMock)
    }

    func test_Block_edit_is_success() {
        // Arrange
        let id = UUID()
        let title = "testTitle"
        let changeTitle = "changeTitle"
        let divideCount = Double(6)
        var model = BlockModel(id: id, title: title, divideCount: divideCount)
        try! blockCreateUseCase.execute(model: model) {}
        
        // Act, Assert
        
        model.title = changeTitle
        do {
            try blockEditUseCase.execute(model: model) {}
            XCTAssertEqual(coreDataRepositoryMock.blockModel?.title, changeTitle)
        } catch {
            XCTFail()
        }
    }
}
