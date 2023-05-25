//
//  EnvironmentValues+ViewEnvironment.swift
//  WorkflowSwiftUI
//
//  Created by Tom Brow on 5/25/23.
//

import SwiftUI
import WorkflowUI

private struct ViewEnvironmentKey: EnvironmentKey {
    static let defaultValue: ViewEnvironment = .empty
}

public extension EnvironmentValues {
    var viewEnvironment: ViewEnvironment {
        get { self[ViewEnvironmentKey.self] }
        set { self[ViewEnvironmentKey.self] = newValue }
    }
}
