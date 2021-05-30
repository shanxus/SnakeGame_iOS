//
//  SnakeViewModel.swift
//  SnakeGameiOS
//
//  Created by Shan OvO on 2021/5/30.
//

import Foundation

protocol SnakeViewModelDelegate: class {
    func mapSize() -> (Int, Int)
    func gameDidUpdate()
    func gameDidEnd()
}

class SnakeViewModel {
    // MARK: - Properties
    weak var delegate: SnakeViewModelDelegate?
    
    // MARK: - Constructor
    init() {
        initialize()
    }
    
    // MARK: - Public function
    func startGame(mapSize: (Int, Int)) {
        SnakeManager.shared.startGame(mapSize: mapSize)
    }
    
    func updateSnakeMovingDirection(_ direction: Direction) {
        switch direction {
        case .up:
            SnakeManager.shared.updateSnakeDirection(direction: .down)
        case .down:
            SnakeManager.shared.updateSnakeDirection(direction: .up)
        case .left:
            SnakeManager.shared.updateSnakeDirection(direction: .right)
        case .right:            
            SnakeManager.shared.updateSnakeDirection(direction: .left)
        }
    }
    
    func isSnakeOccupied(at position: NodePosition) -> Bool {
        return SnakeManager.shared.snake?.nodes.contains { NodePositionUtils.isAtSamePosition(leftNode: ($0, $1), rightNode: position) } ?? false
    }
    
    func isCoin(at position: NodePosition) -> Bool {
        guard let coin = SnakeManager.shared.coin else { return false }
        return NodePositionUtils.isAtSamePosition(leftNode: coin, rightNode: position)
    }
    
    // MARK: - Private function
    private func initialize() {
        SnakeManager.shared.delegate = self
    }
    
}

// MARK: - SnakeManagerDelegate
extension SnakeViewModel: SnakeManagerDelegate {
    func gameDidUpdate() {
        delegate?.gameDidUpdate()
    }
    
    func mapSize() -> (Int, Int) {
        return delegate?.mapSize() ?? (0, 0)
    }
    
    func gameDidEnd() {
        delegate?.gameDidEnd()
    }
}
