//
//  SnakeManager.swift
//  SnakeGameiOS
//
//  Created by Shan OvO on 2021/5/29.
//

import Foundation

protocol SnakeManagerDelegate: class {
    func gameDidStart(snake: Snake?, coin: NodePosition)
    func snakeDidUpdate(snake: Snake?)
    func coinDidUpdate(coin: NodePosition)
    func mapSize() -> (Int, Int)
}

enum GameStatus {
    case started, ended
}

class SnakeManager {
    // MARK: - Properties
    private var cycleTimer: Timer?
    static let shared = SnakeManager()
    private var snake: Snake?
    weak var delegate: SnakeManagerDelegate?
    private var gameStatus: GameStatus = .ended
    private var coin: NodePosition?
    private var speed: TimeInterval = 0.3
    
    private init() {}
    
    // MARK: - Public function.
    func startGame(mapSize: (Int, Int)) {
        guard gameStatus == .ended else { return }
        gameStatus = .started
        
        let center = (mapSize.0 / 2, mapSize.1 / 2)
        snake = Snake(startPosition: center)
        coin = generatePositionForCoin()
        delegate?.gameDidStart(snake: snake, coin: coin!)
        setupCycleTimer()
    }

    func updateSnakeDirection(direction: Direction) {
        snake?.updateDirection(direction)
    }
    
    // MARK: - Private function.
    private func setupCycleTimer() {
        cycleTimer = Timer.init(timeInterval: speed, target: self, selector: #selector(cycleTimerAction), userInfo: nil, repeats: true)
        let runLoop = RunLoop.main
        runLoop.add(cycleTimer!, forMode: .common)
    }
    
    @objc
    private func cycleTimerAction() {
        // Move.
        snake?.move()
        // Check getting point.
        checkGettingCoin()
        delegate?.snakeDidUpdate(snake: snake)
        
        // Check end game.
        if isGameOver() {
            cycleTimer?.invalidate()
            cycleTimer = nil
            NSLog("Game over!")
        }
    }
    
    private func generatePositionForCoin() -> NodePosition {
        var legal = false
        var randomX = 0
        var randomY = 0
        if let mapSize = delegate?.mapSize(), let snake = snake {
            while !legal {
                randomX = Int.random(in: 0..<mapSize.0)
                randomY = Int.random(in: 0..<mapSize.1)
                legal = !snake.isOccupied(node: (randomX, randomY))
            }
            NSLog("Legal coin was generated at (%d, %d)", randomX, randomY)
        }
        return (randomX, randomY)
    }
    
    private func isGameOver() -> Bool {
        if let snake = snake, let mapSize = delegate?.mapSize() {
            if snake.length == mapSize.0 * mapSize.1 {
                NSLog("Win the game by filling the map.")
                return true
            }
            
            if snake.doesHitBody() {
                NSLog("Lose the game by hitting body.")
                return true
            }
            
            if snake.doesHitBoundary(mapWidth: mapSize.0, mapHeight: mapSize.1) {
                NSLog("Lose the game by hitting boundary.")
                return true
            }
        }        
        return false
    }
    
    private func checkGettingCoin() {
        if let snake = snake, let coin = coin, NodePositionUtils.isAtSamePosition(leftNode: snake.head, rightNode: coin) {
            snake.increase()
        }
    }
}

