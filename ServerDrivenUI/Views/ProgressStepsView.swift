//
//  ScheduleASchoolVisitView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 04/05/22.
//

import SwiftUI
import Resolver

struct ProgressStepsView: View {
    
    @Injected var viewModel: ProgressStepsViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        List{
           
            ForEach(viewModel.components, id:\.uniqueId){
                $0.render()
            }
           
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem (placement: .principal) {
                VStack {
                    Text("Steps").font(.headline)
                    Text("Schedule  A School Visit").font(.subheadline)
                }
            }
            
            ToolbarItem (placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    init() {
        viewModel.loadData()
    }
}

struct ScheduleASchoolVisitView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressStepsView()
    }
}
