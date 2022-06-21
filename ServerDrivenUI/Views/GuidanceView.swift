//
//  MarkdownTextView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 26/04/22.
//

import SwiftUI
import Resolver

struct GuidanceView: View {
    
    @InjectedObject var viewModel: GuidanceViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack {
            Divider()
            ScrollView {
                
                ForEach (viewModel.formComponents, id:\.uniqueId){ component in
                    component.render().padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(viewModel.formModel.pageTitle).font(.headline)
                    Text(viewModel.formModel.pageSubTitle ?? "").font(.subheadline)
                }
            }
        }
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
        }))
        
    }
    
    init() {
        self.viewModel.loadData()
    }
}

struct MarkdownTextView_Previews: PreviewProvider {
    static var previews: some View {
        GuidanceView()
    }
}
