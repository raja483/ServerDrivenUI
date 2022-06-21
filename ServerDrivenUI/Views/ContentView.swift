//
//  ContentView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 26/04/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var showMarkdownView = false
    @State var serverDrivenUI = false
//"Guidance",  "Schedile A School Visit"
    @State var listData = ["Add a Scheduled Visit"] //, "Create your Question List"
    
    var body: some View {

        NavigationView{
        
        VStack{
            
            List {
                ForEach(listData, id: \.self){ obj in
                    HStack {
                        NavigationLink(obj) {
                            getDestinationView(obj: obj)
                        }
                    }
                }
            }.listStyle(.plain)
            
        }
        .navigationTitle("Dyanamic forms")
        }
    }
    
    func getDestinationView(obj: String) -> AnyView {
        
        var view = GuidanceView().toAnyView()
        if obj == "Schedile A School Visit" {
            view = ProgressStepsView().toAnyView()
        }
        else if obj == "Add a Scheduled Visit" {
            view = AddSchoolView().toAnyView()
//            ScheduledVisit(viewModel: ScheduledVisitViewModel()).toAnyView()
        }
        else if obj == "Create your Question List" {
            view = CreateQuestionListView().toAnyView()
        }
        
        return view
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
