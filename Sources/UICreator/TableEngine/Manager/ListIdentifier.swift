//
//  File.swift
//  
//
//  Created by brennobemoura on 01/11/20.
//

import Foundation

extension List {
    @usableFromInline
    struct Identifier<ID, Content> {
        let id: ID
        let content: Content
        
        init(_ id: ID, _ content: Content) {
            self.id = id
            self.content = content
        }
    }
}
