import Foundation

public indirect enum CHIndexNode: Equatable, Hashable, Identifiable {

    case root
    case leaf(Int)
    case nested(parent: CHIndexNode, index: Int)

    public var id: [Int] {
        switch self {
        case .root:
            return [0]
        case .leaf(let index):
            return [index]
        case .nested(parent: let parent, index: let index):
            return parent.id + [index]
        }
    }
}
