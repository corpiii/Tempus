//
//  BlockFetchUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/18.
//

import XCTest

final class BlockFetchUseCaseTest: XCTestCase {
    var blockCreateUseCase: BlockCreateUseCase!
    var blockFetchUseCase: BlockFetchUseCase!
    var coreDataRepositoryMock: DataManagerRepositoryMock!
    
    override func setUpWithError() throws {
        coreDataRepositoryMock = DataManagerRepositoryMock()
        blockCreateUseCase = BlockCreateUseCase(repository: coreDataRepositoryMock)
        blockFetchUseCase = BlockFetchUseCase(repository: coreDataRepositoryMock)
    }
    
    func test_Block_fetch_is_success() {
        // Arrange
        let id = UUID()
        let title = "testTitle"
        let divideCount = 6
        let model = BlockModel(id: id, title: title, divideCount: divideCount)
        
        try! blockCreateUseCase.execute(model: model) {}
        
        // Act, Assert
        do {
            try blockFetchUseCase.execute { models in
                XCTAssertEqual(models.first!.id, id)
            }
        } catch {
            XCTFail()
        }
    }
}
