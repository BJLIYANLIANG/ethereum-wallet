//
//  PinPinViewController.swift
//  ethereum-wallet
//
//  Created by Artur Guseynov on 12/03/2018.
//  Copyright © 2018 Artur Guseinov. All rights reserved.
//

import UIKit


class PinViewController: UIViewController {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var placeholders: [PinSignPlaceholderView]!
  @IBOutlet var deleteSignButton: UIButton!
  @IBOutlet var touchIDButton: UIButton!
  @IBOutlet var placeholdersX: NSLayoutConstraint!
  @IBOutlet var termsTextView: UITextView!

  var output: PinViewOutput!


  // MARK: Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    output.viewIsReady()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    output.viewWillAppear()
  }
  
  // MARK: Privates
  
  private func animatePlaceholders(_ placeholders: [PinSignPlaceholderView], toState state: PinSignPlaceholderView.State) {
    for placeholder in placeholders {
      placeholder.animateState(state)
    }
  }
  
  private func animatePlacehodlerAtIndex(_ index: Int, toState state: PinSignPlaceholderView.State) {
    guard index < placeholders.count && index >= 0 else { return }
    placeholders[index].animateState(state)
  }
  
  private func animateWrongPassword() {
    animatePlaceholders(placeholders, toState: .error)
    
    placeholdersX?.constant = -40
    view.layoutIfNeeded()
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.2,
      initialSpringVelocity: 0,
      options: [],
      animations: {
        
        self.placeholdersX?.constant = 0
        self.view.layoutIfNeeded()
    },
      completion: { completed in
        self.animatePlaceholders(self.placeholders, toState: .inactive)
    })
  }
  
  // MARK: Actions
  
  @IBAction func numberPressed(_ sender: UIButton) {
    output.didAddSign(String(sender.tag))
  }
  
  @IBAction func deletePressed(_ sender: UIButton) {
    output.didDeleteSign()
  }
  
  @IBAction func touchIdPressed(_ sender: UIButton) {
    output.didTouchIdPressed()
  }
  

}


// MARK: - PinViewInput

extension PinViewController: PinViewInput {
    
  func setupInitialState() {
    deleteSignButton.isTransparent = true
  }
  
  func didSucceed() {
    animatePlaceholders(placeholders, toState: .inactive)
  }
  
  func didFailed() {
    deleteSignButton.isTransparent = true
    animateWrongPassword()
  }
  
  func didChangeState() {
    deleteSignButton.isTransparent = true
    animatePlaceholders(placeholders, toState: .inactive)
  }
  
  func didAddSignAtIndex(_ index: Int) {
    deleteSignButton.isTransparent = false
    animatePlacehodlerAtIndex(index, toState: .active)
  }
  
  func didRemoveSignAtIndex(_ index: Int) {
    if index == 0 {
      deleteSignButton.isTransparent = true
    }
    animatePlacehodlerAtIndex(index, toState: .inactive)
  }
  
  func didReceivePinInfo(_ info: PinInfo) {
    titleLabel.text = info.title
    touchIDButton.isTransparent = !info.isTouchIDAllowed
    navigationItem.hidesBackButton = !info.isCancellable
  }

}
