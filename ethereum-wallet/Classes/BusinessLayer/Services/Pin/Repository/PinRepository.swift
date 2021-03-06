// Copyright © 2018 Conicoin LLC. All rights reserved.
// Created by Artur Guseinov

import UIKit

class PinRepository: PinRepositoryProtocol {
  
  let keychain: Keychain
  
  init(keychain: Keychain) {
    self.keychain = keychain
  }
  
  var hasPin: Bool {
    return keychain.passphrase != nil
  }
  
  var pin: [String]? {
    guard let passphrase = keychain.passphrase else {
      return nil
    }
    return passphrase.map { String($0) }
  }
  
  func savePin(_ pin: [String]) {
    let pin = pin.joined()
    keychain.passphrase = pin
  }
  
  func deletePin() {
    keychain.passphrase = nil
  }

}
