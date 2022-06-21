//
//  CHQuoteView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI
 

struct CHQuoteView: View {

    let node: QuoteNode

    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: 5)
            VStack(alignment: .leading) {
                CHNodesResolverView(parentIndex: .root, nodes: node.nodes)
            }
        }
    }
}

struct CHQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        CHQuoteView(node: .quote(nodes: [
            .text("A very inspirational quote")
        ]))
    }
}
