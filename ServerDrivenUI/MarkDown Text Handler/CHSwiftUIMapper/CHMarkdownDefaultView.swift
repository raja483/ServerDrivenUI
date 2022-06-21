//
//  SwiftUIView.swift
//  
//
//  Created by Philip Niedertscheider on 10.09.21.
//

import SwiftUI

public struct CHMarkdownDefaultView: View {

    public let text: String

    public init(text: String) {
        self.text = text
    }

    public var body: some View {
        CHMarkdownView(text: text) { nodes in
            CHNodesResolverView(nodes: nodes)
        }
    }
}

struct CHMarkdownDefaultView_Previews: PreviewProvider {

    static let text = """
    Styling a view is the most important part of building beautiful user interfaces. When it comes to the actual code syntax, we want reusable, customizable and clean solutions in our code.

    This article will show you these 3 ways of styling a `SwiftUI.View`:

    1. Initializer-based configuration
    2. Method chaining using return-self
    3. Styles in the Environment
    """

    static var previews: some View {
        ScrollView {
            CHMarkdownDefaultView(text: text)
                .padding()
        }
    }
}
