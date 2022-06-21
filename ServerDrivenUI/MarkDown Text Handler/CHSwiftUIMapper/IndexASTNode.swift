import Foundation
 

public struct IndexASTNode: Hashable, Identifiable {

    public let index: CHIndexNode
    public let node: ASTNode

    public var id: String {
        index.id.map(\.description).joined(separator: "-") + "|" + node.description
    }
}
