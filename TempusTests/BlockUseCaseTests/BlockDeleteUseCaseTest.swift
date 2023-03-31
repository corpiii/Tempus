//
//  BlockDeleteUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/01.
//

import XCTest

final class BlockDeleteUseCaseTest: XCTestCase {
    var blockCreateUseCase: BlockCreateUseCase!
    var blockDeleteUseCase: BlockDeleteUseCase!
    var coreDataRepositoryMock: DataManagerRepositoryMock!
    
    override func setUpWithError() throws {
        coreDataRepositoryMock = DataManagerRepositoryMock()
        blockCreateUseCase = BlockCreateUseCase(repository: coreDataRepositoryMock)
        blockDeleteUseCase = BlockDeleteUseCase(repository: coreDataRepositoryMock)
    }

    func test_Block_delete_is_success() {
        // Arrange
        let id = UUID()
        let title = "testTitle"
        let divideCount = Double(6)
        let model = BlockModel(id: id, title: title, divideCount: divideCount)
        try! blockCreateUseCase.execute(model: model) {}
        
        // Act, Assert
        do {
            try blockDeleteUseCase.execute(model: model) {}
            XCTAssertNil(coreDataRepositoryMock.blockModel)
        } catch {
            XCTFail()
        }
    }
}
