//
//  LinkButtonComponentView.swift
//
//
//  Created by James Borthwick on 2024-08-21.
//

import Foundation
import RevenueCat
import SwiftUI

#if PAYWALL_COMPONENTS

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct LinkButtonComponentView: View {

    let viewModel: LinkButtonComponentViewModel

    var locale: Locale {
        return viewModel.locale
    }

    var component: PaywallComponent.LinkButtonComponent {
        return viewModel.component
    }

    var url: URL {
        component.url
    }

    var body: some View {
        EmptyView()
//        Link(destination: url) {
//            TextComponentView(locale: locale, component: component.textComponent)
//                .cornerRadius(25)
//        }
    }

}

#endif
