//
//  ElevatorsApp.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/23/22.
//

import SwiftUI

@main
struct ElevatorsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .environmentObject(MultiElevatorDispatcher(numberOfElevators: 10, numberOfFloors: 6, capacity: 5))
//                .environmentObject(SingleElevatorDispatcher(numberOfFloors: 6, capacity: 5))
        }
    }
}
