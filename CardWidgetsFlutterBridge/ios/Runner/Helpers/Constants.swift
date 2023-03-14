//
//  Constants.swift
//
//

import Foundation

struct Constants {
    static let email = "juan.perez@pomelo.la"
    static let cardholderName = "Juan Perez"
    static let cardId = "crd-2LQY6Jrh6ScnBaJT7JHcX36ecQG"
    static let lastFourCardDigits = "8016"
    static let image = "TarjetaVirtual"
    static let endPoint = "https://api-stage.pomelo.la/cards-sdk-be-sample/token"
}

enum WidgetMethodCall: String {
    case launchCardViewWidget
    case launchBottomSheetWidget
    case launchPinWidget
    case launchActivationWidget
}
