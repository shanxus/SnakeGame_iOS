//
//  NodePositionUtils.swift
//  SnakeGame
//
//  Created by Shan OvO on 2021/5/29.
//

import Foundation

class NodePositionUtils {
    static let step: Int = 1
    
    static func getNodePosition(from position: NodePosition, toward direction: Direction) -> NodePosition {
        
        switch direction {
        case .up:
            return (position.0, position.1  + step)
        case .down:            
            return (position.0, position.1  - step)
        case .left:
            return (position.0 + step, position.1)
        case .right:
            return (position.0 - step, position.1)
        }
    }
    
    static func getNodeDirection(targetNode: NodePosition, previousNode: NodePosition) -> Direction? {
        if targetNode.0 == previousNode.0 {
            return targetNode.1 < previousNode.1 ? .down : .up
        }
        
        if targetNode.1 == previousNode.1 {
            return targetNode.0 < previousNode.0 ? .right : .left
        }
        
        return nil
    }
    
    static func isAtSamePosition(leftNode: NodePosition, rightNode: NodePosition) -> Bool {
        return leftNode.0 == rightNode.0 && leftNode.1 == rightNode.1
    }
}
