//
//  FlutterRegistryPlugin.swift
//  Runner
//
//  Created by Luciana Sorbelli on 27/03/2023.
//

import Foundation
import Flutter

class FLPlugin: NSObject, FlutterPlugin {
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let factory = FlutterNativeHostingViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "CardPlatformView")
    }
}
