//
//  CHInlineCodeView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI
 

struct CHInlineCodeView: View {

    let node: CodeNode

    var body: some View {
        Text(node.content)
            .padding(2)
            .background(Color(white: 0.85))
    }
}

struct CHInlineCodeView_Previews: PreviewProvider {
    static var previews: some View {
        CHInlineCodeView(node: .code("int main() { return 0; }"))
    }
}
