//
//  FlutterNativeView.swift
//  Runner
//
//  Created by Luciana Sorbelli on 27/03/2023.
//

import Foundation
import Flutter
import PomeloCards

class FlutterNativeView: NSObject, FlutterPlatformView {
    
    private var _view: UIView
    
    init(withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMesssenger messenger: FlutterBinaryMessenger?) {
        
        _view = UIView()
        super.init()
        createNative(view: _view)
    }
    
    func view() -> UIView {
        return _view
    }
    
    func createNative(view: UIView) {
        let cardView = PomeloCardWidgetView(cardholderName: Constants.cardholderName,
                                            lastFourCardDigits: Constants.lastFourCardDigits,
                                            imageFetcher: PomeloImageFetcher(image: UIImage(named: Constants.image)!))
        cardView.frame = CGRect(x: 0, y: 0, width: 180, height: 100)
        _view.addSubviews(cardView)
    }
}
