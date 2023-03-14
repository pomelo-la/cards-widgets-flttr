import UIKit
import Flutter
import PomeloNetworking
import PomeloUI
import PomeloCards

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
    var navigationController: UINavigationController?
    var messageChannel: FlutterMethodChannel?
    let flutterMethodManager = WidgetMethodsManager()
    let client = ClientAuthorizationService()
    
    override func application( _ application: UIApplication,
                             didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
      
        let controller : FlutterViewController = HomeViewController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = UINavigationController(rootViewController: controller)
        window?.rootViewController = navigationController
        window.makeKeyAndVisible()

        setupPomeloSDK()
          ///Channel declaration,  setup the safe communication bridge between iOS and flutter
          ///The channel identifier is the same from both sides
        messageChannel = FlutterMethodChannel(name: "com.example.app/message", binaryMessenger: controller.binaryMessenger)
        messageChannel?.setMethodCallHandler({ [weak self] (call: FlutterMethodCall,
                                                            result: @escaping FlutterResult) -> Void in
                let method = call.method
                let widgetController = self?.flutterMethodManager.launchWidget(by: method)
                self?.navigationController?.present( widgetController!, animated: true)
                
                ///Flutter communication
                self?.receiveMessageFromFlutter(message: method)
                result("Received message with method: \(method)")
            })
      
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
  
    @objc func setupPomeloSDK() {
        PomeloNetworkConfigurator.shared.configure(authorizationService: client)
        PomeloUIGateway.shared.initialize()
        PomeloCards.initialize(with: PomeloCardsConfiguration(environment: .staging))
    }
    
    ///Response back to Flutter,  trigger a new channel method if prefered
    private func receiveMessageFromFlutter(message: String) {
        messageChannel?.invokeMethod("receivedMessageFromiOSSide", arguments: [message])
    }
}
