//
//  CHListBulletItemView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI
 

struct CHListBulletItemView: View {

    let index: CHIndexNode
    let node: BulletNode

    var body: some View {
        HStack(alignment: .top) {
            Text("·")
            VStack(alignment: .leading) {
                CHNodesResolverView(parentIndex: index, nodes: node.nodes)
            }
        }
    }
}

struct CHListBulletItemView_Previews: PreviewProvider {
    static var previews: some View {
        CHListBulletItemView(index: .root, node: .init(nodes: [
            .text("Simple Bullet Item")
        ]))
    }
}
