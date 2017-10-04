//
//  ViewController.swift
//  Sample App
//
//  Created by Miles Hollingsworth on 10/3/17.
//  Copyright © 2017 Miles Hollingsworth. All rights reserved.
//

import UIKit
import DisappearingCollectionViewController

private let reuseIdentifier = "Cell"

class CollectionViewController: DisappearingCollectionViewController {
  // MARK: UICollectionViewDataSource
  
  var cellCount = 2
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellCount
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
  }
  
  @IBAction func insertCell() {
    cellCount += 1
    UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
      self.collectionView?.insertItems(at: [IndexPath(item: 0, section: 0)])
    }, completion: nil)
    
    if cellCount > 20 {
      deleteCell()
    }
  }
  
  @IBAction func deleteCell() {
    cellCount -= 1
    UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
      self.collectionView?.deleteItems(at: [IndexPath(item: self.cellCount, section: 0)])
    }, completion: nil)
  }
  
  @IBAction func swap() {
    UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
      self.collectionView?.moveItem(at: IndexPath(item: 0, section: 0), to: IndexPath(item: 3, section: 0))
    }, completion: nil)
  }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 40.0)
  }
}
