# Landing Flutter

## Create Project
As default customization, you can start your flutter app running ```flutter create app_name```

## Setup iOS workspace
As you have your flutter app already created, you need to setup the iOS internal environment here: 

<img width="242" alt="Screenshot 2023-03-28 at 15 51 50" src="https://user-images.githubusercontent.com/103046888/228339359-05095811-d979-442e-9f8e-f1e40fe16114.png">

I recommend you to open the iOS folder using XCode IDE. 
Once you open the iOS folder, you will have to import ```PomeloCardsSDK``` library using Swift Package Manager, Select you project, go to Package Dependencies and add ```git@github.com:pomelo-la/cards-ios.git```

<img width="479" alt="Screenshot 2023-03-28 at 15 58 18" src="https://user-images.githubusercontent.com/103046888/228340148-75cc86e5-6ead-476b-9b86-30f604d34add.png">


<img width="470" alt="Screenshot 2023-03-28 at 15 58 57" src="https://user-images.githubusercontent.com/103046888/228340274-92dadd63-5d21-489f-8a5c-8796498b5475.png">

- Setup minimum deployment target to iOS 13.0 or later

<img width="471" alt="Screenshot 2023-03-28 at 16 00 07" src="https://user-images.githubusercontent.com/103046888/228340596-9b23877e-94c7-4492-83e4-bdc79be46531.png">

- Setup NSFaceIDUsageDescription on info.plist with the appropriate message. 
- Ex: ```$(PRODUCT_NAME) uses Face ID to validate your identity```

<img width="480" alt="Screenshot 2023-03-28 at 16 01 14" src="https://user-images.githubusercontent.com/103046888/228340772-c97bb326-a395-4278-8fb7-24ff6874da8f.png">

## Setup Method Channel

Method channel is the tool we chose to setup a safe connection between flutter app and iOS native methods. To achieve this, you will need to configure both sides, flutter and iOS:

### Flutter side: 

Choose a channel ID (String variable) and create the channel with that identifier; in the example below, 
the id chosen is "com.example.app/message". 

```dart I'm A tab
class _MyAppState extends State<MyApp> {
  static const platform = const MethodChannel('com.example.app/message');
  (...)
}
```
Once the channel is defined, we call it ‘platform’, we are able to send and receive data between both sides.

### Receiving data from iOS

To receive data, you have to implement the method setMethodCallHandler, in the example, we configured it on the init method: 

```dart I'm A tab
  @override
    void initState() {
      super.initState();

      platform.setMethodCallHandler((MethodCall call) async {
        (...)
      });
    }
```

Inside this implementation, flutter will receive the methods called by the iOS side.

### Sending data to iOS

As you need to fetch iOS methods, you can access to those ones by using the ‘invokeMethod’ function with the string name of the iOS method you need to invoke, check the example below  as we need to execute the ‘launchCardViewWidget’ iOS method : 

```dart I'm A tab
  await platform.invokeMethod('launchCardViewWidget');
```

Here you have another example executing ```sendMessageToiOS``` method with an argument’: 

```dart I'm A tab
  await platform.invokeMethod('sendMessageToiOS', {"message": message});
```

A complete method to define those invocation methods would be this one: 

```dart I'm A tab
  void _sendMessageToiOS(String message) async {
    String responseMessage = "";
    try {
      responseMessage =
          await platform.invokeMethod('sendMessageToiOS', {"message": message});
    } on PlatformException catch (e) {
      print("Failed to send message: '${e.message}'.");
    }
    setState(() {
      _responseMessage = responseMessage;
    });
  }
  
```
### iOS Side

To complete the method channel configuration, we need to setup the AppDelegate, which is the main entry point of an iOS app: 

   As a few steps before you added the packages, now you need to import manually those dependencies 
   to the appDelegate file, at the top of it: 
    
  ```swift I'm A tab
  import UIKit
  import Flutter
  import PomeloNetworking
  import PomeloUI
  import PomeloCards
  ```
  
  AppDelegate class, inherits from UIApplicationDelegate by default, but, we need to make this class inherits from FlutterAppDelegate:
  
  ```swift 
  @UIApplicationMain
  @objc class AppDelegate: FlutterAppDelegate {
    (...)
  }
  ``` 
  Moreover, we need to mark with override keyword the method didFinishLaunchingWithOptions: 
  
  ```swift 
  override func application( _ application: UIApplication,
                             didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
    (...)
  }
  ```
  
  With this new inheritance from FlutterAppDelegate, the appDelegate loses some native properties, so it is needed to provide them. One of them, is the     UIWindow reference, this object describe the main frame that allows us to present the rootViewController, so, inside the    
  didFinishLaunchWithOptionsMethod, copy this code:
     
  ```swift 
  let controller : FlutterViewController = HomeViewController()
  self.window = UIWindow(frame: UIScreen.main.bounds)
  navigationController = UINavigationController(rootViewController: controller)
  window?.rootViewController = navigationController
  window.makeKeyAndVisible()
  ```
 
This way, we are adding a custom viewController ( ```HomeViewController()```) as our first controller of the iOS app, in addition, this controller is a FlutterViewController object type that handle the execution of the Flutter engine within an iOS view. This means that it can be used to display a Flutter UI within a native iOS app screen, allowing for tighter integration between the native part of the app and the Flutter part.
Now that we have our ```FlutterViewController``` as the root one, we need to remove the default root view instance from the project, it is the storyboard and their references, move to trash de Main.storyboard file: 

<img width="200" alt="Screenshot 2023-03-28 at 16 27 57" src="https://user-images.githubusercontent.com/103046888/228346422-bd4f9629-1ace-47f8-848f-e529dce6e389.png">

And remove from the Info.plist file, the row ```Main storyboard file base name```

<img width="381" alt="Screenshot 2023-03-28 at 16 29 11" src="https://user-images.githubusercontent.com/103046888/228346714-7f72ef25-d41b-428d-bcad-5ddd669e238e.png">

After that, we will setup the methodChannel property as an optional type into the AppDelegate class 

```swift 
  var messageChannel: FlutterMethodChannel?
```

### Receiving data from Flutter 

Finally, as you have your ```FlutterViewController``` object and your ```methodChannel``` property, now you are able to finish the connection, 
providing a new ```FlutterMethodChannel``` object with the ```binaryMessenger``` object and calling the ```setMethodCallHandler```, needed to receive the calls from Flutter side:

```swift 
   messageChannel = FlutterMethodChannel(name: "com.example.app/message", binaryMessenger: controller.binaryMessenger)
   messageChannel?.setMethodCallHandler({ [weak self] (call: FlutterMethodCall,
                                                            result: @escaping FlutterResult) -> Void in
            
        (...)
   })
```
The BinaryMessenger class provides methods for sending and receiving messages of two types: basic messages and platform messages.

### Sending data to Flutter

As flutter side, the method to call external methos is ‘invokeMethod’ with the ID (string) of these one, check the example below: 

```swift 
  messageChannel?.invokeMethod("receivedMessageFromiOSSide", arguments: [message])
```

## Configuration

### Authorization

To initialize Pomelo Cards SDK, we need to provide an end user token. All the logic is implemented in swift on the iOS side, you can check how to do that here: https://github.com/pomelo-la/cards-ios/tree/feature/documentation#3-authorization
You need to setup PomeloNetworking environment to get and decode the valid token, so create a new class to delegate the functionality: 

```swift 
  //
//  ClientAuthorizationService.swift
//  Runner
//

import Foundation
import PomeloNetworking

class ClientAuthorizationService: PomeloAuthorizationServiceProtocol {
    
    var clientToken: String?
    
    func getValidToken(completionHandler: @escaping (String?) -> Void) {
        let session = URLSession.shared
        guard let urlRequest = buildRequest(email: Constants.email) else {
            print("\(String.userTokenError) cannot build request")
            completionHandler(nil)
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("\(String.userTokenError) \(error)")
                completionHandler(nil)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let dto = try decoder.decode(PomeloAccessTokenDTO.self, from: data!)
                completionHandler(dto.accessToken)
            } catch {
                print("\(String.userTokenError) \(error.localizedDescription)")
                completionHandler(nil)
            }
        }
        task.resume()
    }
    
    private func buildRequest(email: String) -> URLRequest? {
        let url = URL(string: Constants.endPoint)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        let body = [
            String.BodyParams.email: "\(email)"
        ]
        
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .withoutEscapingSlashes
            urlRequest.httpBody = try jsonEncoder.encode(body)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: String.AuthHeaders.contentType)
        return urlRequest
    }
}

fileprivate extension String {
    static let userTokenError = "Cards Sample App error!🔥 - EndUserTokenService: "

    struct AuthHeaders {
        static let contentType = "Content-Type"
    }
    
    struct BodyParams {
        static let userId = "user_id"
        static let email = "email"
    }
}

```
In addition, it is needed a test user to try, so create a struct with the full data: 

 ```swift 
 struct Constants {
    static let email = "juan.perez@pomelo.la"
    static let cardholderName = "Juan Perez"
    static let cardId = "crd-2LQY6Jrh6ScnBaJT7JHcX36ecQG"
    static let lastFourCardDigits = "8016"
    static let image = "TarjetaVirtual"
    static let endPoint = "https://api-stage.pomelo.la/cards-sdk-be-sample/token"
}
```
In the ```AppDelegate``` class, you can create the variable to use the client: 

```swift
let client = ClientAuthorizationService()
```

Now you are able to initialize ```PomeloCards```: 

```swift
  PomeloNetworkConfigurator.shared.configure(authorizationService: client)
  PomeloUIGateway.shared.initialize()
  PomeloCards.initialize(with: PomeloCardsConfiguration(environment: .staging))
```

### Theme
To customize the iOS theme you should setup your own theme as explained here: https://github.com/pomelo-la/cards-ios/tree/feature/documentation#customizing

## Usage

### Card widget
An example of how you can insert PomeloCardViewController on your flutter app

```swift
    private func getCard() -> UIViewController {
        let widgetView = PomeloCardWidgetView(cardholderName: Constants.cardholderName,
                       lastFourCardDigits: Constants.lastFourCardDigits,
                       imageFetcher: PomeloImageFetcher(image: UIImage(named: Constants.image)!))
        return (CardViewController(cardWidgetView: widgetView, cardId: Constants.cardId))
    }
```

<img width="326" alt="Screenshot 2023-03-28 at 16 59 20" src="https://user-images.githubusercontent.com/103046888/228353761-632d9b2e-c908-4475-8f9e-e8f3a062c4fa.png">


### Card bottom sheet widget  

```swift
  private func getCardList() -> UIViewController {
        let widgetDetailViewController = PomeloCardWidgetDetailViewController()
        widgetDetailViewController.showSensitiveData(cardId: Constants.cardId,
                               onPanCopy: {
          print("Pan was coppied")
        }, completionHandler: { result in
          switch result {
          case .success(): break
          case .failure(let error):
            print("Sensitive data error: \(error)")
          }
        })
        return widgetDetailViewController
    }
  ```
<img width="188" alt="Screenshot 2023-03-28 at 16 51 57" src="https://user-images.githubusercontent.com/103046888/228353554-31588072-7454-4fe1-bb13-140ef7214572.png">


### Activate card widget 

```swift
  private func getActivationCardWidget() -> UIViewController {
        let widgetCardActivationViewController = PomeloWidgetCardActivationViewController(completionHandler: { result in
        switch result {
            case .success(let cardId):
            print("Card was activated. Card id: \(String(describing: cardId))")
            case .failure(let error):
            print("error")
            }
        })
        return widgetCardActivationViewController
    }
```
<img width="324" alt="Screenshot 2023-03-28 at 16 59 38" src="https://user-images.githubusercontent.com/103046888/228353467-0eb2181d-bc33-40b7-beae-c734afcfb415.png">


### Change pin widget

```swift
  private func getPinWidget() -> UIViewController {
        let widgetChangePinViewController = PomeloWidgetChangePinViewController(cardId: Constants.cardId,
                                            completionHandler: { result in
          switch result {
          case .success(): break
          case .failure(let error):
            print("Change pin error: \(error)")
          }
        })
        return widgetChangePinViewController
    }
```

<img width="338" alt="Screenshot 2023-03-28 at 17 02 36" src="https://user-images.githubusercontent.com/103046888/228353930-5826a276-bc22-4c6a-9d9c-63d11532b6f2.png">

The final flutter screen of this project should look like this: 

<img width="323" alt="Screenshot 2023-03-28 at 16 56 57" src="https://user-images.githubusercontent.com/103046888/228354056-214ed164-c1af-42d6-aa6f-1e0fb4187f14.png">


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
