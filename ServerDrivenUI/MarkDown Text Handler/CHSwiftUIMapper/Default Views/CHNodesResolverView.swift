//
//  SwiftUIView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI


struct CHNodesResolverView: View {

    let indexNodes: [IndexASTNode]

    init(parentIndex index: CHIndexNode, nodes: [ASTNode]) {
        self.indexNodes = CHSwiftUIMapper.transformToIndex(parentIndex: index, nodes: nodes)
    }

    init(nodes: [IndexASTNode]) {
        self.indexNodes = nodes
    }

    var body: some View {
        ForEach(indexNodes) { node in
            CHNodeResolverView(node: node)
        }
    }
}
