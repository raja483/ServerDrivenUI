//
//  AddSchoolView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 19/06/22.
//

import SwiftUI
import Resolver

struct AddSchoolView: View {
    
    @Injected var viewModel: AddSchoolViewModel
    
    @State var showSuccessScreen = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                viewModel.view
                Spacer()
                Button("Done") {
                    self.showSuccessScreen = true
                }
                .frame(width: geo.size.width - 32, height: 44)
                .foregroundColor(.white)
                .background(Color(uiColor: UIColor(named: "color_5673185")!))
                .cornerRadius(5)
                
            }
            .padding([.bottom])
        }
        .sheet(isPresented: $showSuccessScreen) {
            
        } content: {
            
            let data =  viewModel.getData()
            let successModel = SuccessViewModel(data: data)
            SuccessView(viewModel: successModel)
        }

    }
}

struct AddSchoolView_Previews: PreviewProvider {
    static var previews: some View {
        AddSchoolView()
    }
}
