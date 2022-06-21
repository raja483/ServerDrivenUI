//
//  SuccessView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 30/04/22.
//

import SwiftUI

struct SuccessView: View {
    
    var viewModel: SuccessViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading){
            Text("Which school are you visiting:").font(.system(.title3))
            Text(viewModel.fromWhichScool)
            }.padding()
            
            VStack(alignment: .leading){
                Text("Date Range:")
                Text("From \(viewModel.startDate) to \(viewModel.endDate)")
            }.padding()
         
            VStack(alignment: .leading){
                Text("Tour Date:")
                Text(viewModel.tourDate)
            }.padding()
            
            VStack(alignment: .leading) {
                Text("Start Location:")
                Text(viewModel.startLocation)
            }.padding()
            
            VStack(alignment: .leading) {
                Text("Parking Location:")
                Text(viewModel.parkingLocation)
            }.padding()
            
        }
    }
}
    
    struct SuccessView_Previews: PreviewProvider {
        static var previews: some View {
            SuccessView(viewModel: SuccessViewModel())
        }
    }
