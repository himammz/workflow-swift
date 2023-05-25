//
//  WithModel.swift
//  WorkflowSwiftUI
//
//  Created by Tom Brow on 5/25/23.
//

import SwiftUI

struct WithModel<Model, Content: View>: View {
    @ObservedObject private var model: ObservableValue<Model>
    private let content: (ObservableValue<Model>) -> Content

    init(
        _ model: ObservableValue<Model>,
        @ViewBuilder content: @escaping (ObservableValue<Model>) -> Content
    ) {
        self.model = model
        self.content = content
    }

    var body: Content {
        content(model)
    }
}
