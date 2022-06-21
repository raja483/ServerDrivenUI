//
//  SwiftUIView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI
 

struct CHLinkView: View {

    let index: CHIndexNode
    let node: LinkNode

    var body: some View {
        Button(action: {}) {
            CHNodesResolverView(parentIndex: index, nodes: node.nodes)
        }
    }
}

struct CHLinkView_Previews: PreviewProvider {
    static var previews: some View {
        CHLinkView(index: .root,
                   node: .init(
                    uri: "https://example.org",
                    title: "Example Link",
                    nodes: [
                        .bold("This"),
                        .text("is"),
                        .cursive("some content")
                    ]))
    }
}
