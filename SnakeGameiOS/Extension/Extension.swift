//
//  Extension.swift
//  SnakeGameiOS
//
//  Created by Shan OvO on 2021/5/30.
//

import UIKit

extension UISwipeGestureRecognizer.Direction {
    func getDirection() -> Direction? {
        switch self {
        case .up:
            return .up
        case .down:
            return .down
        case .left:
            return .left
        case .right:
            return .right
        default:
            return nil
        }
    }
}

extension IndexPath {
    var position: (Int, Int) {
        return (item, section)
    }
}
