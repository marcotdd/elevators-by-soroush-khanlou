//
//  Person.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/23/22.
//

import SwiftUI

struct PersonView: View {
    let call: Passenger
    var body: some View {
        Image(systemName: call.figure)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 15, height: 30)
    }
}
