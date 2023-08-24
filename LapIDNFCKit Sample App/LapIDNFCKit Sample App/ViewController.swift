//
//  ViewController.swift
//  LapIDNFCKit Sample App
//
//  Created by Manuel Mayer on 24.08.23.
//

import UIKit
import LapIDNFCKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func checkDeviceCompatibilityTapped(_ sender: Any) {
        NFCService.shared.checkDeviceCompatibility(caller: self)
    }
    
    @IBAction func nfcNotImmediatelyTapped(_ sender: Any) {
        NFCService.shared.nfcCheck(caller: self)
    }
    
    @IBAction func nfcImmediatelyTapped(_ sender: Any) {
        NFCService.shared.nfcCheck(caller: self, scanImmediately: true)
    }
}

