//
//  Snake.swift
//  SnakeGame
//
//  Created by Shan OvO on 2021/5/29.
//

import Foundation

enum Direction {
    case up, down, left, right
    
    func getOpposite() -> Direction {
        switch self {
        case .up:
            return .down
        case .down:
            return .up
        case .left:
            return .right
        case .right:
            return .left
        }
    }
}

typealias NodePosition = (Int, Int)

class Snake {
    // MARK: - Properties
    private(set) var nodes: [NodePosition] = []
    
    var head: NodePosition {
        return nodes.first!
    }
    
    var tail: NodePosition {
        return nodes.last!
    }
    
    var length: Int {
        return nodes.count
    }
    
    private(set) var direction: Direction = .right
    
    // MARK: - Constructor
    init(length: Int = 3, startPosition: NodePosition, direction: Direction = .right) {
        var previous: NodePosition = (0, 0)
        
        for i in 0..<length {
            if i == 0 {
                nodes.append(startPosition)
                previous = startPosition;
            } else {
                previous = NodePositionUtils.getNodePosition(from: previous, toward: direction.getOpposite())
                nodes.append(previous)
            }
        }
    }
    
    // MARK: - Public functions.
    func updateDirection(_ direction: Direction) {
        self.direction = direction
    }
    
    func move() {
        for i in (1..<length).reversed() {
            nodes[i] = nodes[i-1]
        }        
        nodes[0] = NodePositionUtils.getNodePosition(from: nodes[0], toward: direction)
    }
    
    
    func isOccupied(node position: NodePosition) -> Bool {
        return nodes.contains { $0 == position.0 && $1 == position.1 }
    }
    
    func doesHitBody() -> Bool {
        let filtered = nodes.filter { $0 == head.0 && $1 == head.1 }
        return filtered.count > 1
    }
    
    
    func doesHitBoundary(mapWidth: Int, mapHeight: Int) -> Bool {
        return (head.0 < 0 || head.0 > mapWidth - 1 || head.1 < 0 || head.1 > mapHeight - 1)
    }
    
    func increase() {
        let tailMoveDirection = NodePositionUtils.getNodeDirection(targetNode: tail, previousNode: nodes[length-2])        
        let newTail = NodePositionUtils.getNodePosition(from: tail, toward: tailMoveDirection!.getOpposite())
        nodes.append(newTail)
    }
    // MARK: - Private functions.
    
}
