//
//  ServerDrivenUIApp.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 26/04/22.
//

import SwiftUI
import Resolver


@main
struct ServerDrivenUIApp: App {
    
    init(){
        Resolver.registerAllServices()
        UIDatePicker.appearance().backgroundColor = UIColor.init(.white)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
        
        register {
            ScheduledVisitViewModel()
        }
        register {
            GuidanceViewModel()
        }
        register {
            ProgressStepsViewModel()
        }
        register { resolver in
            AddSchoolViewModel()
        }
    }
}
