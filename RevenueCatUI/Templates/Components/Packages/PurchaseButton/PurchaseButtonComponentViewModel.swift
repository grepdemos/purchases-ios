//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  PurchaseButtonComponentViewModel.swift
//
//  Created by Josh Holtz on 9/27/24.

import Foundation
import RevenueCat
import SwiftUI

#if PAYWALL_COMPONENTS

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
class PurchaseButtonComponentViewModel {

    private let localizedStrings: PaywallComponent.LocalizationDictionary
    private let component: PaywallComponent.PurchaseButtonComponent

    let stackViewModel: StackComponentViewModel

    init(
        packageValidator: PackageValidator,
        localizedStrings: PaywallComponent.LocalizationDictionary,
        component: PaywallComponent.PurchaseButtonComponent,
        offering: Offering
    ) throws {
        self.localizedStrings = localizedStrings
        self.component = component

        self.stackViewModel = try StackComponentViewModel(
            packageValidator: packageValidator,
            component: component.stack,
            localizedStrings: localizedStrings,
            offering: offering
        )
    }

}

#endif
