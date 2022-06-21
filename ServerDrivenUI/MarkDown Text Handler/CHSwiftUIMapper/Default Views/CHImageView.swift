//
//  CHImageView.swift
//  
//
//  Created by Philip Niedertscheider on 11.09.21.
//

import SwiftUI

struct CHImageView: View {

    let node: ImageNode

    var body: some View {
        VStack {
//            KFImage(URL(string: node.uri))
//                .resizable()
//                .cornerRadius(15)
//                .aspectRatio(contentMode: .fit)
            if let title = node.title {
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct CHImageView_Previews: PreviewProvider {
    static var previews: some View {
        CHImageView(node: .image(uri: "https://via.placeholder.com/100",
                                 title: "Title",
                                 nodes: [
                                    .text("This is a caption with "),
                                    .bold("some bold text")
                                 ]))
    }
}
