//
//  SwiftUIScreen.swift
//  WorkflowSwiftUI
//
//  Created by Tom Brow on 5/25/23.
//

import SwiftUI
import Workflow
import WorkflowUI

public protocol SwiftUIScreen: Screen {
    associatedtype Content: View

    @ViewBuilder
    static func makeView(model: ObservableValue<Self>) -> Content

    static var isDuplicate: ((Self, Self) -> Bool)? { get }
}

public extension SwiftUIScreen {
    static var isDuplicate: ((Self, Self) -> Bool)? { return nil }
}

public extension SwiftUIScreen where Self: Equatable {
    static var isDuplicate: ((Self, Self) -> Bool)? { { $0 == $1 } }
}

public extension SwiftUIScreen {
    func viewControllerDescription(environment: ViewEnvironment) -> ViewControllerDescription {
        ViewControllerDescription(
            type: ModeledHostingController<Self, WithModel<Self, EnvironmentInjectingView<Content>>>.self,
            build: {
                let (model, modelSink) = ObservableValue.makeObservableValue(self, isDuplicate: Self.isDuplicate)
                let (viewEnvironment, envSink) = ObservableValue.makeObservableValue(environment)
                return ModeledHostingController(
                    modelSink: modelSink,
                    viewEnvironmentSink: envSink,
                    rootView: WithModel(model, content: { model in
                        EnvironmentInjectingView(
                            viewEnvironment: viewEnvironment,
                            content: Self.makeView(model: model)
                        )
                    })
                )
            },
            update: {
                $0.modelSink.send(self)
                $0.viewEnvironmentSink.send(environment)
            }
        )
    }
}

private struct EnvironmentInjectingView<Content: View>: View {
    @ObservedObject var viewEnvironment: ObservableValue<ViewEnvironment>
    let content: Content

    var body: some View {
        content
            .environment(\.viewEnvironment, viewEnvironment.value)
    }
}

private final class ModeledHostingController<Model, Content: View>: UIHostingController<Content> {
    let modelSink: Sink<Model>
    let viewEnvironmentSink: Sink<ViewEnvironment>

    init(modelSink: Sink<Model>, viewEnvironmentSink: Sink<ViewEnvironment>, rootView: Content) {
        self.modelSink = modelSink
        self.viewEnvironmentSink = viewEnvironmentSink

        super.init(rootView: rootView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
}
