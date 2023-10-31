//
//  ElevatorView.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/23/22.
//

import SwiftUI

let elevatorHeight: CGFloat = 60
let elevatorWidth: CGFloat = 50

struct ElevatorView: View {

    @ObservedObject var elevator: Elevator

    var body: some View {
        Rectangle()
            .overlay(alignment: .bottom) {
                VStack(spacing: 0) {
                    if elevator.passengers.count > 3 {
                        Spacer()
                        Text(" +\(elevator.passengers.count - 3)")
                            .bold()
                    }
                    HStack(spacing: 1) {
                        ForEach(elevator.passengers.prefix(3)) { call in
                            PersonView(call: call)
                        }
                    }
                }
                .foregroundColor(.black)
            }
            .frame(width: elevatorWidth, height: elevatorHeight)
            .overlay(alignment: .top, content: {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(Color.gray)
                    .offset(.init(width: 4, height: -10))

                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(Color.gray)
                    .offset(.init(width: -4, height: -10))
            })
            .border(Color.gray, width: 2)
            .offset(.init(width: 0, height: -elevator.floorPosition * elevatorHeight))
    }
}
