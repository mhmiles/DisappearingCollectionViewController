//
//  VisibleCollectionViewLayout.swift
//  DisappearingCollectionViewController
//
//  Created by Miles Hollingsworth on 9/22/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import UIKit

open class VisibleCollectionViewLayout: UICollectionViewFlowLayout {
  fileprivate var insertedIndexPaths: [IndexPath]?
  fileprivate var deletedIndexPaths: [IndexPath]?
  
  open override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
    super.prepare(forCollectionViewUpdates: updateItems)
    
    insertedIndexPaths = updateItems.filter({ $0.updateAction == .insert }).map { $0.indexPathAfterUpdate! }
    deletedIndexPaths = updateItems.filter({ $0.updateAction == .delete }).map { $0.indexPathBeforeUpdate! }
  }
  
  override open func finalizeCollectionViewUpdates() {
    super.finalizeCollectionViewUpdates()
    
    insertedIndexPaths = nil
    deletedIndexPaths = nil
  }
  
  open override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return layoutAttributesForItem(at: itemIndexPath).map {
      let attributes = $0.copy() as! UICollectionViewLayoutAttributes
      
      if let insertedIndexPaths = insertedIndexPaths, insertedIndexPaths.contains(itemIndexPath) {
        attributes.transform.tx = -collectionView!.frame.width
      }
      
      return attributes
    }
  }
}
