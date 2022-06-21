//
//  CHListView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI

struct CHListView: View {

    let index: CHIndexNode
    let node: ListNode

    var body: some View {
        VStack(alignment: .leading) {
            CHNodesResolverView(parentIndex: index, nodes: node.nodes)
        }
    }
}

struct CHListView_Previews: PreviewProvider {
    static var previews: some View {
        CHListView(index: .root, node: .list(nodes: [
            .bullet(nodes: [
                .text("Bullet Item")
            ]),
            .numbered(index: 1, nodes: [
                .text("Numbered Item")
            ])
        ]))
    }
}
