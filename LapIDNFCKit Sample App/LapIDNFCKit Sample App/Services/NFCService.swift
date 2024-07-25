//
//  NFCService.swift
//  LapIDNFCKit Sample App
//
//  Created by Manuel Mayer on 24.08.23.
//

import Foundation
import LapIDNFCKit
import UIKit

class NFCService {
    static let shared = NFCService()
    
    var uiViewController: UIViewController? = nil
    
    func checkDeviceCompatibility(caller: UIViewController) {
        let compatibility = LapIDNFC.shared.checkDeviceCompatibility()
        switch compatibility {
        case .ok:
            caller.present(informationAlert(message: "Everything looks fine, this device is compatible"), animated: true)
        case .noNFC:
            caller.present(informationAlert(message: "Unfortunately this device has no NFC"), animated: true)
        case .osVersionTooLow:
            caller.present(informationAlert(message: "Unfortunately this device's os version is too low"), animated: true)
        default:
            caller.present(informationAlert(message: "Unknown result. Check the documentation for changes."), animated: true)
        }
    }
    
    func nfcCheck(caller: UIViewController, scanImmediately: Bool = false) {
        OperationQueue.main.addOperation {
            self.uiViewController = caller;
            let viewController = LapIDNFC.shared.start(delegate: self, scanImmediately: scanImmediately)
            caller.present(viewController, animated: true)
        }
    }
    
    func informationAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(
            title: "Information",
            message: message,
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Close", style: .cancel))

        return alert
    }
}

extension NFCService: LapIDNFCKitDelegate {
    func didReturn(with result: LapIDNFCKitResult) {
        switch result {
        case .checkCompleted(let succesul, let driverId, let externalDriverId):
            self.uiViewController?.present(informationAlert(message: String("The check is completed\nSuccesful: \(succesul)\nDriver Id: \(driverId)\nExternal Driver Id: \(externalDriverId)")), animated: true)
            self.uiViewController = nil
        case .stationfinder:
            self.uiViewController?.present(informationAlert(message: "The label is incompatible with the SDK and now the user is looking for a LapID checking station. You might want to present a WKWebView (https://developer.apple.com/documentation/webkit/wkwebview) or similar to allow them to visit the LapID Stationfinder."), animated: true)
            self.uiViewController = nil
            break;
        case .canceled:
            self.uiViewController?.present(informationAlert(message: "The check was canceled due to an error or as a result of a user interaction. You can use this information to update your UI accordingly."), animated: true)
            self.uiViewController = nil
            break;
        default:
            self.uiViewController?.present(informationAlert(message: "Unknown result. Check the documentation for changes."), animated: true)
            self.uiViewController = nil
        }
    }
}
