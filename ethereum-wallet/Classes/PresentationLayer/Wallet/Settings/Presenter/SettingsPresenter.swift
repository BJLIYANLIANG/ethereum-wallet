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


class SettingsPresenter {
    
  weak var view: SettingsViewInput!
  weak var output: SettingsModuleOutput?
  var interactor: SettingsInteractorInput!
  var router: SettingsRouterInput!
  
  var currencies = Constants.Wallet.supportedCurrencies
  var selectedCurrency = Constants.Wallet.defaultCurrency
}


// MARK: - SettingsViewOutput

extension SettingsPresenter: SettingsViewOutput {

  func viewIsReady() {
    view.setupInitialState()
    interactor.getWallet()
  }
  
  func didCurrencyPressed() {
    router.presentChooseCurrency(from: view.viewController, selectedIso: selectedCurrency, output: self)
  }
  
  func didChangePasscodePressed() {
    
  }
  
  func didBackupPressed() {
    
  }
  
  func didTouchIdValueChanged(_ isOn: Bool) {
    
  }
  
  func didLogoutPressed() {
    
  }

}


// MARK: - SettingsInteractorOutput

extension SettingsPresenter: SettingsInteractorOutput {
  
  func didReceiveWallet(_ wallet: Wallet) {
    selectedCurrency = wallet.localCurrency
    let currency = FiatCurrencyFactory.create(iso: wallet.localCurrency)
    view.didReceiveCurrency(currency)
  }
  
  func didStoreKey(at url: URL) {
  }
  
  func didClearAllData() {
    router.presentWelcome()
  }
  
  func didFailed(with error: Error) {
    error.showAllertIfNeeded(from: view.viewController)
  }

}


// MARK: - SettingsModuleInput

extension SettingsPresenter: SettingsModuleInput {
  
  var viewController: UIViewController {
    return view.viewController
  }

}


// MARK: - ChooseCurrencyModuleOutput

extension SettingsPresenter: ChooseCurrencyModuleOutput {
  
  func didSelectCurrency(_ currency: FiatCurrency) {
    view.didReceiveCurrency(currency)
    interactor.selectCurrency(currency.iso)
  }
  
}
