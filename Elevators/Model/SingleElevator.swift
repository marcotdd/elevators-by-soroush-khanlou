//
//  SingleElevator.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/27/22.
//

import Foundation

@MainActor
final class SingleElevatorDispatcher: Dispatcher, ObservableObject, Identifiable {

    let id = UUID()

    let numberOfFloors: Int

    let capacity: Int

    @Published var queue: [Passenger] = []

    @Published var direction: Direction = .up

    @Published var floorPosition: Double = 0

    var elevators: [SingleElevatorDispatcher] {
        [self]
    }

    init(numberOfFloors: Int, capacity: Int) {
        self.numberOfFloors = numberOfFloors
        self.capacity = capacity
        loop()
    }

    func enqueue(passenger: Passenger) {
        queue.append(passenger)
    }

    var passengers: [Passenger] {
        queue.filter(\.isCarCall)
    }

    func loop() {
        Task {
            while true {
                if hasCallsAtCurrentLocation && (hasCapacity || hasPassengersToAlight) {
                    try await openDoors()
                    alightPassengers()
                    boardNewPassengers()
                    try await closeDoors()
                }
                try await tick()
                if hasCallsInCurrentDirection {
                    floorPosition += self.direction.multiplier * 0.1
                } else if !queue.isEmpty {
                    direction.flip()
                } else {
                    continue
                }
            }
        }
    }

    func tick() async throws {
        try await Task.sleep(nanoseconds: 16*mSecPerSec)
    }

    func openDoors() async throws {
        try await Task.sleep(nanoseconds: 200*mSecPerSec)
    }

    func closeDoors() async throws {
        try await Task.sleep(nanoseconds: 200*mSecPerSec)
    }

    func boardNewPassengers() {
        for index in queue.indices {
            let call = queue[index].call

            guard call.kind == .hallCall else { continue }

            guard isAt(floor: call.from) else { continue }

            guard call.direction == self.direction else { continue }

            guard hasCapacity else { continue }

            queue[index].boardElevator()
        }
    }

    func alightPassengers() {
        for index in queue.indices.reversed() {
            let call = queue[index].call
            if call.kind == .carCall, isAt(floor: call.to) {
                queue.remove(at: index)
            }
        }
    }

    var hasCallsInCurrentDirection: Bool {
        switch direction {
        case .up:
            return hasCallAboveElevator
        case .down:
            return hasCallBelowElevator
        }
    }

    var hasCallsAtCurrentLocation: Bool {
        return queue.contains(where: { passenger in
            self.isAt(floor: passenger.destination) && passenger.call.direction == direction
        })
    }

    var hasPassengersToAlight: Bool {
        passengers.contains(where: { $0.isCarCall && self.isAt(floor: $0.destination) })
    }

    var hasCallAboveElevator: Bool {
        return queue.contains(where: { floorPosition - Double($0.destination) < -0.01 })
    }

    var hasCallBelowElevator: Bool {
        return queue.contains(where: { floorPosition - Double($0.destination) > 0.01 })
    }

    var hasCapacity: Bool {
        passengers.count < capacity
    }

    func isAt(floor: Int) -> Bool {
        isAt(floor: Double(floor))
    }

    func isAt(floor: Double) -> Bool {
        abs(floor - floorPosition) < 0.01
    }
}
