//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  StoreKit2PurchaseIntentListener.swift
//
//  Created by Will Taylor on 10/10/24.

import StoreKit

@available(iOS 16.4, tvOS 15.0, macOS 12.0, watchOS 8.0, *)
protocol StoreKit2PurchaseIntentListenerDelegate: AnyObject, Sendable {

    func storeKit2PurchaseIntentListener(
        _ listener: StoreKit2PurchaseIntentListenerType,
        purchaseIntent: StorePurchaseIntent
    ) async

}

@available(iOS 16.4, tvOS 15.0, macOS 12.0, watchOS 8.0, *)
protocol StoreKit2PurchaseIntentListenerType: Sendable {

    func listenForPurchaseIntents() async

    func set(delegate: StoreKit2PurchaseIntentListenerDelegate) async

}

/// Observes `StoreKit.PurchaseIntent.intents`, which receives purchase intents, which indicate that
/// subscriber customer initiated a purchase outside of the app, for the app to complete.
@available(iOS 16.4, tvOS 15.0, macOS 12.0, watchOS 8.0, *)
actor StoreKit2PurchaseIntentListener: StoreKit2PurchaseIntentListenerType {

    private(set) var taskHandle: Task<Void, Never>?

    private weak var delegate: StoreKit2PurchaseIntentListenerDelegate?

    // We can't directly store instances of `AsyncStream`, since that causes runtime crashes when
    // loading this type in iOS <= 15, even with @available checks correctly in place.
    // See https://openradar.appspot.com/radar?id=4970535809187840 / https://github.com/apple/swift/issues/58099
    private let _updates: Box<AsyncStream<StorePurchaseIntent>>

    var updates: AsyncStream<StorePurchaseIntent> {
        return self._updates.value
    }

    init(delegate: StoreKit2PurchaseIntentListenerDelegate? = nil) {

        let storePurchaseIntentSequence = StoreKit.PurchaseIntent.intents.map { purchaseIntent in
            return StorePurchaseIntent(purchaseIntent: purchaseIntent)
        }.toAsyncStream()

        self.init(
            delegate: delegate,
            updates: storePurchaseIntentSequence
        )
    }

    /// Creates a listener with an `AsyncSequence` of `VerificationResult<Transaction>`s
    /// By default `StoreKit.Transaction.updates` is used, but a custom one can be passed for testing.
    init<S: AsyncSequence>(
        delegate: StoreKit2PurchaseIntentListenerDelegate? = nil,
        updates: S
    ) where S.Element == StorePurchaseIntent {
        self.delegate = delegate
        self._updates = .init(updates.toAsyncStream())
    }

    func set(delegate: any StoreKit2PurchaseIntentListenerDelegate) async {
        self.delegate = delegate
    }

    func listenForPurchaseIntents() async {
        Logger.debug(Strings.storeKit.sk2_observing_purchase_intents)

        self.taskHandle?.cancel()
        self.taskHandle = Task(priority: .utility) { [weak self, updates = self.updates] in
            for await purchaseIntent in updates {
                guard let self = self else {
                    break
                }

                // Important that handling purchase intents doesn't block the thread
                Task.detached {
                    await self.delegate?.storeKit2PurchaseIntentListener(self, purchaseIntent: purchaseIntent)
                }
            }
        }
    }

    deinit {
        self.taskHandle?.cancel()
        self.taskHandle = nil
    }
}

@available(iOS 16.4, tvOS 15.0, macOS 14.4, *)
struct StorePurchaseIntent: Sendable, Equatable {
    let purchaseIntent: PurchaseIntent?
}
