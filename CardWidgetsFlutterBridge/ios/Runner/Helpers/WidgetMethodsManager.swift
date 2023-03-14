//
// WidgetMethodsManager.swift
// Runner
//
import Foundation
import PomeloCards

class WidgetMethodsManager {
    
    init(){}
    
    func launchWidget(by call: String) -> UIViewController {
        switch call {
            case WidgetMethodCall.launchPinWidget.rawValue: return getPinWidget()
            case WidgetMethodCall.launchCardViewWidget.rawValue: return getCard()
            case WidgetMethodCall.launchBottomSheetWidget.rawValue: return getCardList()
            case WidgetMethodCall.launchActivationWidget.rawValue: return getActivationCardWidget()
            default: break
            }
        return UIViewController()
    }
    
    private func getCard() -> UIViewController {
        let widgetView = PomeloCardWidgetView(cardholderName: Constants.cardholderName,
                       lastFourCardDigits: Constants.lastFourCardDigits,
                       imageFetcher: PomeloImageFetcher(image: UIImage(named: Constants.image)!))
        return (CardViewController(cardWidgetView: widgetView, cardId: Constants.cardId))
    }
    
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
}
