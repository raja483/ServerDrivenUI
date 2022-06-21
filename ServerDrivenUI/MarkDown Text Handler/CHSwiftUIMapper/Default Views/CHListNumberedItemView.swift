//
//  CHListNumberedItemView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI
 

struct CHListNumberedItemView: View {

    let index: CHIndexNode
    let node: NumberedNode

    var body: some View {
        HStack(alignment: .top) {
            Text("\(node.index).")
            VStack(alignment: .leading) {
                CHNodesResolverView(parentIndex: index, nodes: node.nodes)
            }
        }
    }
}

struct CHListNumberedItemView_Previews: PreviewProvider {
    static var previews: some View {
        CHListNumberedItemView(index: .root, node: .numbered(index: 1, nodes: [
            .text("My First Item")
        ]))
    }
}
