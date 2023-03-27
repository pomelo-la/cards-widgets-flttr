//
//  FlutterNativeHostingViewFactory.swift
//  Runner
//
//  Created by Luciana Sorbelli on 27/03/2023.
//

import Flutter
import Foundation

class FlutterNativeHostingViewFactory: NSObject, FlutterPlatformViewFactory {
    
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger ) {
        self.messenger = messenger
        super.init()
    }
    
    func create(withFrame frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?) -> FlutterPlatformView {
     
        return FlutterNativeView(withFrame: frame,
                                 viewIdentifier: viewId,
                                 arguments: args,
                                 binaryMesssenger: messenger)
    }
}
