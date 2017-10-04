//
//  ViewController.swift
//  Sample App
//
//  Created by Miles Hollingsworth on 10/4/17.
//  Copyright © 2017 Miles Hollingsworth. All rights reserved.
//

import UIKit
import DisappearingCollectionViewController

class ViewController: UIViewController {
  var disappearingCollectionViewController: DisappearingCollectionViewController!
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }
    
    switch identifier {
    case "DisappearingCollectionViewControllerSegue":
      disappearingCollectionViewController = segue.destination as? DisappearingCollectionViewController
      
    default:
      print("Unhandled segue: \(identifier)")
    }
  }
  
  @IBAction func handleShowButtonPress(_ sender: Any) {
    disappearingCollectionViewController.showCells()
  }
}
