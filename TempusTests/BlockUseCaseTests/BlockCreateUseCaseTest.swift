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
        let title = "testTitle"
        let divideCount = Double(6)
        
        // Act, Assert
        do {
            try blockCreateUseCase.execute(title: title, divideCount: divideCount) {}
        } catch {
            XCTFail()
        }
    }
}
