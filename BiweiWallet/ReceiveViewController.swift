//
//  ReceiveViewController.swift
//
//  Copyright © 2018 Kishikawa Katsumi
//  Copyright © 2018 BitcoinKit developers
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import EthereumKit

class ReceiveViewController: UIViewController {
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var coin:Symbol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = coin.short
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    @IBAction func copyAddress(_ sender: UIButton) {
        print(receiveAddress())
        UIPasteboard.general.string = receiveAddress()
    }

    @IBAction func generateNewAddress(_ sender: UIButton) {
        AppController.shared.externalIndex += 1
        updateUI()
    }

    private func generateVisualCode(address: String) -> UIImage? {
        let parameters: [String : Any] = [
            "inputMessage": address.data(using: .utf8)!,
            "inputCorrectionLevel": "L"
        ]
        let filter = CIFilter(name: "CIQRCodeGenerator", withInputParameters: parameters)

        guard let outputImage = filter?.outputImage else {
            return nil
        }

        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 6, y: 6))
        guard let cgImage = CIContext().createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }

    func receiveAddress() -> String {
        if AppController.shared.isHardWallet {
            //
//            let w = AppController.shared.wallet?.getWallet(key: coin.short!)
//
//            let pkeyBytes = HardWallet.shared.getPublicKey()
//            let pkey:PublicKey = PublicKey( bytes: pkeyBytes, network: w.network)
//            let addr = pkey.toCashaddr().base58 as! Address
//            return addr.base58 ?? ""
            return ""
        }else {
            return AppController.shared.wallet?.getWallet(key: coin.short!)?.getAddress(index: AppController.shared.externalIndex) ?? ""
        }
    }

    private func updateUI() {
        qrCodeImageView.image = generateVisualCode(address: receiveAddress())
        addressLabel.text = receiveAddress()
    }
}
