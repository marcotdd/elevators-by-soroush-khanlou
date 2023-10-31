//
//  Dispatcher.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/27/22.
//

import Foundation

@MainActor
protocol Dispatcher {
    var numberOfFloors: Int { get }
    func enqueue(passenger: Passenger)
}
