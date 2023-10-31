//
//  Passenger.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/27/22.
//

import Foundation

struct Call {
    enum Kind {
        case hallCall, carCall
    }

    var kind: Kind
    var from: Int
    var to: Int

    var direction: Direction {
        Direction(from: from, to: to)
    }
}

struct Passenger: Identifiable {
    static let figures = [
//        "figure.fencing",
//        "figure.dance",
//        "figure.hiking",
//        "figure.roll",
        "figure.pickleball",
        "figure.basketball",
        "figure.skating",
        "figure.archery",
        "figure.badminton",
        "figure.gymnastics",
    ]

    let id = UUID()
    var call: Call
    let figure: String

    static func hallCall(fromFloor: Int, eventualDestination: Int) -> Self {
        return .init(call: .init(kind: .hallCall, from: fromFloor, to: eventualDestination), figure: figures.randomElement()!)
    }

//    static func carCall(toFloor: Int) -> Self {
//        return .init(call: .carCall(toFloor: toFloor), figure: figures.randomElement()!)
//    }

    var destination: Int {
        switch call.kind {
        case .hallCall:
            return call.from
        case .carCall:
            return call.to
        }
    }

    var isCarCall: Bool {
        switch call.kind {
        case .hallCall:
            return false
        case .carCall:
            return true
        }
    }

    mutating func boardElevator() {
        if call.kind == .hallCall {
            call.kind = .carCall
        }
    }

    func isAbove(floor: Double) -> Bool {
        floor - Double(destination) < -0.01
    }

    func isBelow(floor: Double) -> Bool {
        floor - Double(destination) > 0.01
    }

}
