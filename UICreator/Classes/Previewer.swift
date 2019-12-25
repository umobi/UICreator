//
//  Previewer.swift
//  UICreator
//
//  Created by brennobemoura on 23/12/19.
//

import Foundation

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, *)
@available(tvOS 13, *)
public struct LivePreview<View: ViewBuilder>: SwiftUI.View {
    public init() {}
    
    public var body: some SwiftUI.View {
        Previewer<View>()
    }
}

@available(iOS 13, *)
@available(tvOS 13, *)
public struct Previewer<View: ViewBuilder>: UIViewRepresentable {
    public init() {}
    
    public func makeUIView(context: Context) -> View {
        return View()
    }

    public func updateUIView(_ uiView: View, context: Context) {}
}

#endif
