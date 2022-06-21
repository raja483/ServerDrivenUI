//
//  ViewExtension.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 28/04/22.
//

import Foundation
import SwiftUI
import UIKit


extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}

fileprivate var currentOverCurrentContextUIHost: UIHostingController<AnyView>? = nil

extension View {
    
    public func overCurrentContext(
        isPresented: Binding<Bool>,
        showWithAnimation: Bool = false,
        dismissWithAnimation: Bool = false,
        modalTransitionStyle: UIModalTransitionStyle = .crossDissolve,
        modalPresentationStyle: UIModalPresentationStyle = .overCurrentContext,
        afterDismiss: (() -> Void)? = nil,
        content: () -> AnyView
    ) -> some View {
        if isPresented.wrappedValue && currentOverCurrentContextUIHost == nil {
            let uiHost = UIHostingController(rootView: content())
            currentOverCurrentContextUIHost = uiHost
            
            uiHost.modalPresentationStyle = modalPresentationStyle
            uiHost.modalTransitionStyle = modalTransitionStyle
            uiHost.view.backgroundColor = UIColor.clear
            
            let rootVC = UIApplication.shared.windows.first?.rootViewController
            rootVC?.present(uiHost, animated: showWithAnimation, completion: nil)
            
        } else {
            if let uiHost = currentOverCurrentContextUIHost {
                uiHost.dismiss(animated: dismissWithAnimation, completion: {})
                currentOverCurrentContextUIHost = nil
                afterDismiss?()
            }
        }
        
        return self
    }
}
