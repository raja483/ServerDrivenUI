//
//  SwiftUIView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI
 

struct CHNodeResolverView: View {

    let node: IndexASTNode

    var body: some View {
        content
            .id(node.id)
    }

    @ViewBuilder
    var content: some View {
        switch node.node {
        // Simple Nodes
        case let node as TextNode:
            resolveText(node: node)
        case let node as BoldNode:
            resolveBold(node: node)
        case let node as CursiveNode:
            resolveCursive(node: node)
        case let node as CursiveBoldNode:
            resolveCursiveBold(node: node)
        // List Nodes
        case let node as ListNode:
            CHListView(index: self.node.index, node: node)
        case let node as BulletNode:
            CHListBulletItemView(index: self.node.index, node: node)
        case let node as NumberedNode:
            CHListNumberedItemView(index: self.node.index, node: node)
        // Container Nodes
        case let node as ParagraphNode:
            CHParagraphView(index: self.node.index, node: node)
        case let node as HeaderNode:
            CHHeaderView(index: self.node.index, node: node)
        case let node as TextNodesBox:
            CHTextBoxView(node: node)
        case let node as CodeBlockNode:
            CHCodeBlockView(index: self.node.index, node: node)
        case let node as CodeNode:
            CHInlineCodeView(node: node)
        case let node as QuoteNode:
            CHQuoteView(node: node)
        case let node as LinkNode:
            CHLinkView(index: self.node.index, node: node)
        case let node as ImageNode:
            CHImageView(node: node)
        default:
            Text("Missing resolver for node at position \(node.index): " + node.node.description)
        }
    }

    private func resolveText(node: TextNode) -> some View {
        Text(node.content)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func resolveBold(node: BoldNode) -> some View {
        Text(node.content)
            .bold()
            .fixedSize(horizontal: false, vertical: true)
    }

    private func resolveCursive(node: CursiveNode) -> some View {
        Text(node.content)
            .italic()
            .fixedSize(horizontal: false, vertical: true)
    }

    private func resolveCursiveBold(node: CursiveBoldNode) -> some View {
        Text(node.content)
            .italic()
            .bold()
            .fixedSize(horizontal: false, vertical: true)
    }
}

//struct CHNodeResolverView_Previews: PreviewProvider {
//    static var previews: some View {
//        CHNodeResolverView()
//    }
//}
