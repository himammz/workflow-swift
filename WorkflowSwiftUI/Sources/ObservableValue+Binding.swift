//
//  ObservableValue+Binding.swift
//  WorkflowSwiftUI
//
//  Created by Tom Brow on 5/25/23.
//

import SwiftUI

public extension ObservableValue {
    func binding<T>(
        get: @escaping (Value) -> T,
        set: @escaping (Value) -> (T) -> Void
    ) -> Binding<T> {
        // This convoluted way of creating a `Binding`, relative to `Binding.init(get:set:)`, is
        // a workaround borrowed from TCA for a SwiftUI issue:
        // https://github.com/pointfreeco/swift-composable-architecture/pull/770
        ObservedObject(wrappedValue: self)
            .projectedValue[get: .init(rawValue: get), set: .init(rawValue: set)]
    }

    private subscript<T>(
        get get: HashableWrapper<(Value) -> T>,
        set set: HashableWrapper<(Value) -> (T) -> Void>
    ) -> T {
        get { get.rawValue(value) }
        set { set.rawValue(value)(newValue) }
    }

    private struct HashableWrapper<Value>: Hashable {
        let rawValue: Value
        static func == (lhs: Self, rhs: Self) -> Bool { false }
        func hash(into hasher: inout Hasher) {}
    }
}
