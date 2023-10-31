//
//  ContentView.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/23/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dispatcher: MultiElevatorDispatcher

    var body: some View {
        BuildingView()
            .environment(\.numberOfFloors, dispatcher.numberOfFloors)
            .environment(\.numberOfElevators, 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
