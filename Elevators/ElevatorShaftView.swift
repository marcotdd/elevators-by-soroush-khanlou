//
//  SwiftUIView.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/23/22.
//

import SwiftUI

struct ElevatorShaftView: View {
    let controlRoomHeight: CGFloat = 20
    @Environment(\.numberOfFloors) var numberOfFloors
    @ObservedObject var elevator: Elevator

    var body: some View {
        Rectangle()
            .frame(width: elevatorWidth, height: elevatorHeight * CGFloat(numberOfFloors) + controlRoomHeight)
            .border(Color.black)
            .overlay(alignment: .bottom) {
                ElevatorView(elevator: elevator)
                    .padding(1)
            }
    }
}
