//
//  BlockCreateUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/03/31.
//

import XCTest

final class BlockCreateUseCaseTest: XCTestCase {
    var blockCreateUseCase: BlockCreateUseCase!
    var coreDataRepositoryMock: DataManagerRepositoryMock!
    
    override func setUpWithError() throws {
        coreDataRepositoryMock = DataManagerRepositoryMock()
        blockCreateUseCase = BlockCreateUseCase(repository: coreDataRepositoryMock)
    }

    func test_Block_create_is_success() {
        // Arrange
        let id = UUID()
        let title = "testTitle"
        let divideCount = Double(6)
        let model = BlockModel(id: id, title: title, divideCount: divideCount)
        
        // Act, Assert
        do {
            try blockCreateUseCase.execute(model: model) {}
            XCTAssertEqual(coreDataRepositoryMock.blockModel!.id, id)
        } catch {
            XCTFail()
        }
    }
}
