//
//  Algorithms.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/23/22.
//

import Foundation

@MainActor
final class MultiElevatorDispatcher: Dispatcher, ObservableObject {

    let numberOfFloors: Int

    var numberOfElevators: Int {
        elevators.count
    }

    let elevators: [Elevator]

    @Published var queue: [Passenger] = [] // hall calls only

    var queueMinusPassengersAssignedToElevators: [Passenger] {
        return queue
            .filter({ passenger in
                !hallCallsAssignedToElevators
                    .contains(where: { $0.0.id == passenger.id })
            })
    }

    var hallCallsAssignedToElevators: [(Passenger, Elevator)] = []

    init(numberOfElevators: Int, numberOfFloors: Int, capacity: Int) {
        self.numberOfFloors = numberOfFloors
        self.elevators = (0..<numberOfElevators).map({ _ in Elevator(capacity: capacity) })
        elevators.forEach({ $0.dispatcher = self })
    }

    func enqueue(passenger: Passenger) {
        queue.append(passenger)
    }
}

@MainActor
final class Elevator: ObservableObject, Identifiable {
    let id = UUID()
    
    let capacity: Int

    @Published var direction = Direction.up

    @Published var floorPosition: Double = 0

    var passengers: [Passenger] = []

    unowned var dispatcher: MultiElevatorDispatcher!

    init(capacity: Int) {
        self.capacity = capacity
        loop()
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
                    takeHallCallInCurrentDirection()
                    floorPosition += self.direction.multiplier * 0.1
                } else if !hasCallsInCurrentDirection && abs(floorPosition.truncatingRemainder(dividingBy: 1)) >= 0.05 && floorPosition <= Double(dispatcher.numberOfFloors) - 1.1 {
                    floorPosition += self.direction.multiplier * 0.1
                } else if !dispatcher.queue.isEmpty {
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
        for index in dispatcher.queue.indices.reversed() {

            let call = dispatcher.queue[index].call

            guard call.kind == .hallCall else { continue }

            guard isAt(floor: call.from) else { continue }

            guard call.direction == self.direction else { continue }

            guard hasCapacity else { continue }

            var passenger = dispatcher.queue.remove(at: index)

            dispatcher.hallCallsAssignedToElevators.removeAll(where: { $0.0.id == passenger.id })

            passenger.boardElevator()

            passengers.append(passenger)
        }
    }

    func alightPassengers() {
        for index in passengers.indices.reversed() {

            let call = passengers[index].call

            guard call.kind == .carCall else { continue }

            guard isAt(floor: call.to) else { continue }

            passengers.remove(at: index)

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

    func takeHallCallInCurrentDirection() {
        let index: Int?
        switch direction {
        case .up:
            index = dispatcher.queueMinusPassengersAssignedToElevators.indices.first(where: { dispatcher.queueMinusPassengersAssignedToElevators[$0].isAbove(floor: floorPosition) })
        case .down:
            index = dispatcher.queueMinusPassengersAssignedToElevators.indices.first(where: { dispatcher.queueMinusPassengersAssignedToElevators[$0].isBelow(floor: floorPosition) })
        }
        if let index {
            let passenger = dispatcher.queueMinusPassengersAssignedToElevators[index]
            let everyoneWaitingOnThatFloor = dispatcher.queueMinusPassengersAssignedToElevators.filter({ $0.call.kind == .hallCall && $0.call.from == passenger.call.from })
                .prefix(capacity - passengers.count)
            // but only take your capacity!
            dispatcher.hallCallsAssignedToElevators.append(contentsOf: everyoneWaitingOnThatFloor.map({ ($0, self) }))
        }
    }

    var hasCallsAtCurrentLocation: Bool {
        return (dispatcher.queue + passengers).contains(where: { passenger in
            self.isAt(floor: passenger.destination) && passenger.call.direction == direction
        })
    }

    var hasPassengersToAlight: Bool {
        passengers.contains(where: { $0.isCarCall && self.isAt(floor: $0.destination) })
    }

    var hasCallAboveElevator: Bool {
        return (dispatcher.queueMinusPassengersAssignedToElevators + passengers)
            .contains(where: { floorPosition - Double($0.destination) < -0.01 })
    }

    var hasCallBelowElevator: Bool {
        return (dispatcher.queueMinusPassengersAssignedToElevators + passengers)
            .contains(where: { floorPosition - Double($0.destination) > 0.01 })
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
