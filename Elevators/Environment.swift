//
//  Environment.swift
//  Elevators
//
//  Created by Soroush Khanlou on 11/23/22.
//

import SwiftUI

private struct NumberOfFloorsKey: EnvironmentKey {
  static let defaultValue = 0
}

extension EnvironmentValues {
  var numberOfFloors: Int {
    get { self[NumberOfFloorsKey.self] }
    set { self[NumberOfFloorsKey.self] = newValue }
  }
}

private struct NumberOfElevatorsKey: EnvironmentKey {
  static let defaultValue = 0
}

extension EnvironmentValues {
  var numberOfElevators: Int {
    get { self[NumberOfElevatorsKey.self] }
    set { self[NumberOfElevatorsKey.self] = newValue }
  }
}
