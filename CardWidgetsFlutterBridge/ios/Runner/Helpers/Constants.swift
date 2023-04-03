//
//  Constants.swift
//
//

import Foundation

struct Constants {
    static let email = "abel.cruz@pomelo.la"
    static let cardholderName = "Abel Cruz"
    static let cardId = "crd-2IBcMBMMSyeBNrq4Ndl1FMOzPvX"
    static let lastFourCardDigits = "6150"
    static let image = "TarjetaVirtual"
    static let endPoint = "https://api-stage.pomelo.la/cards-sdk-be-sample/token"
}

enum WidgetMethodCall: String {
    case launchCardViewWidget
    case launchBottomSheetWidget
    case launchPinWidget
    case launchActivationWidget
}
