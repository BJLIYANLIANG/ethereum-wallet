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


import Foundation

struct ConfirmPasscodeState: PasscodeStateProtocol {
  
  let title: String
  let isCancellableAction: Bool
  let isTouchIDAllowed: Bool
  
  private var passcodeToConfirm: [String]
  
  init(passcode: [String]) {
    self.passcodeToConfirm = passcode
    self.title = Localized.passcodeConfirmTitle()
    self.isCancellableAction = true
    self.isTouchIDAllowed = false
  }
  
  func acceptPasscode(_ passcode: [String], fromLock lock: PasscodeServiceProtocol) {
    if passcode == passcodeToConfirm {
      lock.repository.savePasscode(passcode)
      lock.delegate?.passcodeLockDidSucceed(lock, acceptedPasscode: passcode)
    } else {
      let mismatchTitle = Localized.passcodeMismatchTitle()
      let nextState = NewPasscodeState(title: mismatchTitle)
      lock.changeStateTo(nextState)
      lock.delegate?.passcodeLockDidFail(lock)
    }
  }
}
