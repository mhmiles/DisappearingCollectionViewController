//
//  HiddenCollectionViewLayout.swift
//  DisappearingCollectionViewController
//
//  Created by Miles Hollingsworth on 9/16/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import UIKit

open class HiddenCollectionViewLayout: UICollectionViewFlowLayout {
  override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return super.layoutAttributesForElements(in: rect)?.map {
      let attributes = $0.copy() as! UICollectionViewLayoutAttributes
      
      if attributes.representedElementCategory == .cell {
        attributes.alpha = 0
      }
      
      return attributes
    }
  }
  
  open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return super.layoutAttributesForItem(at: indexPath).map {
      let attributes = $0.copy() as! UICollectionViewLayoutAttributes
      
      if attributes.representedElementCategory == .cell {
        attributes.alpha = 0
      }
      
      return attributes
    }
  }
  
  open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}
