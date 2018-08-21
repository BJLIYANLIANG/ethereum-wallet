// ethereum-wallet https://github.com/flypaper0/ethereum-wallet
// Copyright (C) 2018 Artur Guseinov
//
// This program is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <http://www.gnu.org/licenses/>.


import UIKit


class ReceiveViewController: UIViewController {
  @IBOutlet var addressLabel: UILabel!
  @IBOutlet var qrImageView: UIImageView!
  @IBOutlet var copyAddressButton: UIButton!
  @IBOutlet var addressTitleLabel: UILabel!
  
  var output: ReceiveViewOutput!


  // MARK: Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    output.viewIsReady()
    localize()
  }
  
  // MARK: Privates
  
  private func localize() {
    addressTitleLabel.text = Localized.receiveAddressTitle()
    copyAddressButton.setTitle(Localized.receiveCopyButton(), for: .normal)
  }
  
  // MARK: Actions
  
  @IBAction func copyAddressPressed() {
    guard let address = addressLabel.text else { return }
    output.copyAddressPressed(address: address)
  }
  
  @IBAction func sharePressed(_ sender: UIBarButtonItem) {
    let text = addressLabel.text!
    let image = qrImageView.image!
    let activity = UIActivityViewController(activityItems: [image, text], applicationActivities: nil)
    activity.excludedActivityTypes = [
      .airDrop,
      .copyToPasteboard,
      .message,
      .mail,
      .postToFacebook,
      .postToTwitter,
      .postToFlickr,
      .markupAsPDF,
    ]
    present(activity, animated: true, completion: nil)
  }

}


// MARK: - ReceiveViewInput

extension ReceiveViewController: ReceiveViewInput {
  
  func didReceiveCoin(_ coin: CoinDisplayable) {
    let title = Localized.receiveTitle(coin.balance.name)
    navigationItem.title = title
  }
  
  func didReceiveWallet(_ wallet: Wallet) {
    addressLabel.text = wallet.address
  }
  
  func didReceiveQRImage(_ image: UIImage) {
    qrImageView.image = image
  }
    
  func setupInitialState() {

  }

}
