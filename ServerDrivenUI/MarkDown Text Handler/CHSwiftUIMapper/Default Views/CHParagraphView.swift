//
//  CHParagraphView.swift
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI

struct CHParagraphView: View {

    let index: CHIndexNode
    let node: ParagraphNode

    var body: some View {
        ForEach(indexNodes) { node in
            HStack(spacing: 0) {
                CHNodeResolverView(node: node)
                Spacer()
            }
        }
    }

    var indexNodes: [IndexASTNode] {
        CHSwiftUIMapper.transformToIndex(parentIndex: index, nodes: node.nodes)
    }
}

struct CHParagraphView_Previews: PreviewProvider {
    static var previews: some View {
        CHParagraphView(index: .root, node: .paragraph(nodes: [
            .text("Segment 1"),
            .text("Segment 2"),
            .text("Segment 3")
        ]))
    }
}
