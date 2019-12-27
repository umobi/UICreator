//
//  Previewer.swift
//  UICreator
//
//  Created by brennobemoura on 23/12/19.
//

import Foundation

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, tvOS 13, *)
public struct LivePreview<View: ViewCreator>: SwiftUI.View {

    let view: View
    init(_ initClass: View) {
        self.view = initClass
    }

    public var body: some SwiftUI.View {
        Previewer<View>(view)
    }
}

@available(iOS 13, tvOS 13, *)
public struct Previewer<View: ViewCreator>: UIViewRepresentable {
    public func makeUIView(context: UIViewRepresentableContext<Previewer<View>>) -> UIView {
        return self.view.uiView
    }

    public typealias UIViewType = UIView

    let view: View

    public init(_ initClass: View) {
        self.view = initClass
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}
}

#endif
