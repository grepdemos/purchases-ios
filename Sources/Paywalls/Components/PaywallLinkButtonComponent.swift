//
//  PaywallLinkButtonComponent.swift
//
//
//  Created by James Borthwick on 2024-08-21.
//

import Foundation


#if PAYWALL_COMPONENTS

public extension PaywallComponent {
    struct LinkButtonComponent: PaywallComponentBase {

        let type: String
        public let url: URL
        public let textComponent: PaywallComponent.TextComponent
        public let displayPreferences: [DisplayPreference]?

        public init(
            url: URL,
            textComponent: PaywallComponent.TextComponent,
            displayPreferences: [DisplayPreference]? = nil
        ) {
            self.type = "button"
            self.url = url
            self.textComponent = textComponent
            self.displayPreferences = displayPreferences
        }

        var focusIdentifiers: [FocusIdentifier]? = nil

    }
}

#endif
