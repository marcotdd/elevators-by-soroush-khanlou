//
//  Building.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/23/22.
//

import SwiftUI

struct BuildingView: View {

    @EnvironmentObject var dispatcher: MultiElevatorDispatcher
    @Environment(\.numberOfFloors) var numberOfFloors

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(spacing: 0) {
                ForEach((0..<numberOfFloors).reversed(), id: \.self) { index in
                    FloorView(floorIndex: index)
                }
            }
            .frame(width: elevatorWidth * 3)

            ElevatorBayView()
        }
        .task {
            try? await dispatcher.simulateRandomTraffic()
        }
    }
}
