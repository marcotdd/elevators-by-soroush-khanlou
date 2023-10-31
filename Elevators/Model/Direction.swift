//
//  Direction.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/27/22.
//

import Foundation

enum Direction: Equatable {
    case up, down

    init(from: Int, to: Int) {
        if from < to {
            self = .up
        } else {
            self = .down
        }
    }

    var multiplier: Double {
        switch self {
        case .up: return +1
        case .down: return -1
        }
    }

    mutating func flip() {
        switch self {
        case .up: self = .down
        case .down: self = .up
        }
    }
}
