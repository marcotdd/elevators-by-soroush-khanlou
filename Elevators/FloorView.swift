//
//  Floor.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/23/22.
//

import SwiftUI

struct FloorView: View {

    let floorIndex: Int

    @EnvironmentObject var dispatcher: MultiElevatorDispatcher

    var waitingCalls: [Passenger] {
        dispatcher.queue.filter({ passenger in
            passenger.call.kind == .hallCall && passenger.call.from == floorIndex
        })
    }

    var upCallRegistered: Bool {
        dispatcher.queue.contains(where: { passenger in
            passenger.call.kind == .hallCall
            && passenger.call.from == floorIndex
            && passenger.call.direction == .up
        })
    }

    var downCallRegistered: Bool {
        dispatcher.queue.contains(where: { passenger in
            passenger.call.kind == .hallCall
            && passenger.call.from == floorIndex
            && passenger.call.direction == .down
        })
    }

    var floorName: String {
        if floorIndex == 0 {
            return "L"
        } else {
            return floorIndex.description
        }
    }

    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(height: elevatorHeight)
            .overlay(alignment: .bottom) {
                HStack {
                    Text(floorName)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    ForEach(waitingCalls.prefix(3)) { call in
                        PersonView(call: call)
                            .foregroundColor(.white)
                    }
                    if waitingCalls.count > 3 {
                        Text(" +\(waitingCalls.count - 3)")
                            .font(.system(size: 16, weight: .bold))
                    }
                    VStack {

                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(upCallRegistered ? .green : .white)
                            .opacity(floorIndex != dispatcher.numberOfFloors - 1 ? 1 : 0.2)

                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(downCallRegistered ? .red : .white)
                            .opacity(floorIndex != 0 ? 1 : 0.2)
                    }
                }
            }
        Divider()
    }
}
