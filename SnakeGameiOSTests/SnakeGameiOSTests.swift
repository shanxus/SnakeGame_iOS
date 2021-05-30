//
//  SnakeGameiOSTests.swift
//  SnakeGameiOSTests
//
//  Created by Shan OvO on 2021/5/29.
//

import XCTest
@testable import SnakeGameiOS

class SnakeGameiOSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Test for Direction.
    func testGetOppositeDirectionHorizontally() {
        XCTAssertTrue(Direction.left.getOpposite() == Direction.right)
    }
    
    func testGetOppositeDirectionVertically() {
        XCTAssertTrue(Direction.up.getOpposite() == Direction.down)
    }
    
    // MARK: - Test for NodePositionUtils
    func testIsAtSamePosition() {
        let leftNode: NodePosition = (0, 0)
        let rightNode: NodePosition = (0, 0)
        XCTAssertTrue(NodePositionUtils.isAtSamePosition(leftNode: leftNode, rightNode: rightNode))
    }
    
    func testNotAtSamePosition() {
        let leftNode: NodePosition = (0, 0)
        let rightNode: NodePosition = (1, 0)
        XCTAssertFalse(NodePositionUtils.isAtSamePosition(leftNode: leftNode, rightNode: rightNode))
    }
    
    func testGetNodeRightPosition() {
        let origin: NodePosition = (0, 0)
        let right: NodePosition = (1, 0)
        XCTAssertTrue(NodePositionUtils.getNodePosition(from: origin, toward: .right) == right)
    }
    
    func testGetNodeLeftPosition() {
        let origin: NodePosition = (0, 0)
        let left: NodePosition = (-1, 0)
        XCTAssertTrue(NodePositionUtils.getNodePosition(from: origin, toward: .left) == left)
    }
    
    func testGetNodeUpPosition() {
        let origin: NodePosition = (0, 0)
        let up: NodePosition = (0, -1)
        XCTAssertTrue(NodePositionUtils.getNodePosition(from: origin, toward: .up) == up)
    }
    
    func testGetNodeDownPostion() {
        let origin: NodePosition = (0, 0)
        let down: NodePosition = (0, 1)
        XCTAssertTrue(NodePositionUtils.getNodePosition(from: origin, toward: .down) == down)
    }
    
    func testGetNodeDirectionForRight() {
        let origin: NodePosition = (0, 0)
        let right: NodePosition = (1, 0)
        XCTAssertTrue(NodePositionUtils.getNodeDirection(targetNode: origin, previousNode: right) == Direction.right)
    }
    
    func testGetNodeDirectionForLeft() {
        let origin: NodePosition = (0, 0)
        let left: NodePosition = (-1, 0)
        XCTAssertTrue(NodePositionUtils.getNodeDirection(targetNode: origin, previousNode: left) == Direction.left)
    }
    
    func testGetNodeDirectionForUp() {
        let origin: NodePosition = (0, 0)
        let up: NodePosition = (0, -1)
        XCTAssertTrue(NodePositionUtils.getNodeDirection(targetNode: origin, previousNode: up) == Direction.up)
    }
    
    func testGetNodeDirectionForDown() {
        let origin: NodePosition = (0, 0)
        let down: NodePosition = (0, 1)
        XCTAssertTrue(NodePositionUtils.getNodeDirection(targetNode: origin, previousNode: down) == Direction.down)
    }
}
