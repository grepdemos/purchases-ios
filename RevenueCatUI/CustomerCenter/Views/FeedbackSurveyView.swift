//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  FeedbackSurveyView.swift
//
//
//  Created by Cesar de la Vega on 12/6/24.
//

import RevenueCat
import SwiftUI

#if os(iOS)

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
struct FeedbackSurveyView: View {

    @StateObject
    private var viewModel: FeedbackSurveyViewModel

    init(feedbackSurveyData: FeedbackSurveyData, localization: CustomerCenterConfigData.Localization) {
        let viewModel = FeedbackSurveyViewModel(feedbackSurveyData: feedbackSurveyData, localization: localization)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            Text(self.viewModel.feedbackSurveyData.configuration.title)
                .font(.title)
                .padding()

            Spacer()

            FeedbackSurveyButtonsView(options: self.viewModel.feedbackSurveyData.configuration.options,
                                      action: self.viewModel.handleAction(for:),
                                      loadingStates: self.$viewModel.loadingStates)
        }
        .sheet(
            item: self.$viewModel.promotionalOfferData,
            onDismiss: { self.viewModel.handleSheetDismiss() },
            content: { promotionalOfferData in
                PromotionalOfferView(promotionalOffer: promotionalOfferData.promotionalOffer,
                                     product: promotionalOfferData.product,
                                     promoOfferDetails: promotionalOfferData.promoOfferDetails,
                                     localization: self.viewModel.localization)
            })
    }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
struct FeedbackSurveyButtonsView: View {

    let options: [CustomerCenterConfigData.HelpPath.FeedbackSurvey.Option]
    let action: (CustomerCenterConfigData.HelpPath.FeedbackSurvey.Option) async -> Void
    @Binding
    var loadingStates: [String: Bool]

    var body: some View {
        VStack(spacing: Self.buttonSpacing) {
            ForEach(options, id: \.id) { option in
                AsyncButton(action: {
                    await self.action(option)
                }, label: {
                    if self.loadingStates[option.id] ?? false {
                        ProgressView()
                    } else {
                        Text(option.title)
                    }
                })
                .buttonStyle(ManageSubscriptionsButtonStyle())
                .disabled(self.loadingStates[option.id] ?? false)
            }
        }
    }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension FeedbackSurveyButtonsView {

    private static let buttonSpacing: CGFloat = 16

}

#endif
