//
//  SwiftUIView.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/23/22.
//

import SwiftUI

struct ElevatorBayView: View {

    @EnvironmentObject var dispatcher: MultiElevatorDispatcher
    @Environment(\.numberOfFloors) var numberOfFloors
    @Environment(\.numberOfElevators) var numberOfElevators

    var body: some View {
        HStack {
            ForEach(dispatcher.elevators) { elevator in
                ElevatorShaftView(elevator: elevator)
                    .padding(1)
            }
        }
    }
}
