//
//  Simulations.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/25/22.
//

import Foundation

let mSecPerSec: UInt64 = 1_000_000

enum SpawnSpeed {
    case slow
    case fast

    func randomMilliseconds() -> UInt64 {
        switch self {
        case .slow:
            return mSecPerSec * .random(in: 200...800)
        case .fast:
            return mSecPerSec * .random(in: 50...100)
        }
    }
}

let spawnSpeed = SpawnSpeed.fast

extension Dispatcher {
    func simulateDownpeakTraffic() async throws {
        while true {
            if Double.random(in: 0..<1) < 0.1 {
                simulateSingleRandomPassenger()
            } else {
                simulatePassengerGoingToLobby()
            }
            try await Task.sleep(nanoseconds: spawnSpeed.randomMilliseconds())
        }
    }

    func simulateUppeakTraffic() async throws {
        while true {
            if Double.random(in: 0..<1) < 0.1 {
                simulateSingleRandomPassenger()
            } else {
                simulatePassengerInLobby()
            }
            try await Task.sleep(nanoseconds: spawnSpeed.randomMilliseconds())
        }
    }

    func simulateRandomTraffic() async throws {
        while true {
            simulateSingleRandomPassenger()
            try await Task.sleep(nanoseconds: spawnSpeed.randomMilliseconds())
        }
    }

    func simulateSingleRandomPassenger() {
        let from = Int.random(in: 0..<numberOfFloors)
        let to = Int.random(in: 0..<numberOfFloors)

        if from != to {
            self.enqueue(passenger: .hallCall(fromFloor: from, eventualDestination: to))
        }
    }

    func simulatePassengerInLobby() {
        let from = 0
        let to = Int.random(in: 1..<numberOfFloors)

        self.enqueue(passenger: .hallCall(fromFloor: from, eventualDestination: to))
    }

    func simulatePassengerGoingToLobby() {
        let from = Int.random(in: 1..<numberOfFloors)
        let to = 0

        self.enqueue(passenger: .hallCall(fromFloor: from, eventualDestination: to))
    }
}
