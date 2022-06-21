//
//  CHCodeBlockView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI
 

struct CHCodeBlockView: View {

    let index: CHIndexNode
    let node: CodeBlockNode

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                CHNodesResolverView(parentIndex: index, nodes: node.nodes)
            }
        }
        .padding(10)
        .background(Color(white: 0.85))
        .cornerRadius(10)
    }
}

struct CHCodeBlockView_Previews: PreviewProvider {

    static var previews: some View {
        CHCodeBlockView(index: .root, node: .init(nodes: [
            .code("Line 1"),
            .code("Line 2"),
            .code("Line 3"),
        ]))
    }
}
