//
//  DisappearingCollectionViewController.swift
//  DisappearingCollectionViewController
//
//  Created by Miles Hollingsworth on 10/3/17.
//  Copyright © 2017 Miles Hollingsworth. All rights reserved.
//

import UIKit
import ReactiveSwift
import enum Result.NoError

private let interval = 0.2

open class DisappearingCollectionViewController: UICollectionViewController {
  public lazy var isVisible: Property<Bool> = {
    return Property(_isVisible)
  }()
  private let _isVisible = MutableProperty(false)
  
  private let timingDisposble = SerialDisposable()
  
  private let hiddenLayout = HiddenCollectionViewLayout()
  private let visibleLayout =  VisibleCollectionViewLayout()
  
  private var visibilityDisposable: ScopedDisposable<AnyDisposable>!
  
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    
    isVisible.producer.startWithValues { [unowned self] (isVisible) in
      self.collectionView!.isScrollEnabled = isVisible
    }
    
    collectionView!.setCollectionViewLayout(hiddenLayout, animated: false)
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    if #available(iOS 11.0, *) {
      collectionView!.contentInsetAdjustmentBehavior = .never
    } else {
      automaticallyAdjustsScrollViewInsets = false
    }
  }
  
  @IBAction public func showCells() {
    if collectionView!.visibleCells.count == 0 {
      collectionView!.setCollectionViewLayout(visibleLayout, animated: false)
      return
    }
    
    collectionView!.visibleCells.forEach {
      $0.transform.tx = -self.collectionView!.frame.width-10
      $0.alpha = 1.0
    }
    
    let sortedCells = collectionView!.indexPathsForVisibleItems.sorted(by: { $0.row < $1.row }).flatMap(collectionView!.cellForItem)
    
    _isVisible.value = true
    timingDisposble.inner = animationProducer(cells: sortedCells,
                                              transform: CGAffineTransform.identity).startWithCompleted {
                                                self.collectionView!.setCollectionViewLayout(self.visibleLayout, animated: false)
    }
  }
  
  @IBAction public func hideCells() {
    let finalContentOffset = CGPoint.zero
    
    if collectionView!.contentOffset.y != finalContentOffset.y {
      collectionView!.setContentOffset(finalContentOffset, animated: true)
    } else {
      finishHidingCells()
    }
  }
  
  public func finishHidingCells() {
    if collectionView!.visibleCells.count == 0 {
      collectionView!.setCollectionViewLayout(hiddenLayout, animated: false)
      return
    }
    
    let sortedCells = collectionView!.indexPathsForVisibleItems.sorted(by: { $0.row < $1.row }).flatMap(collectionView!.cellForItem)
    
    _isVisible.value = false
    let transform = CGAffineTransform(translationX: -self.collectionView!.frame.width-10.0, y: 0.0)
    timingDisposble.inner = animationProducer(cells: sortedCells,
                                              transform: transform).startWithCompleted {
                                                self.collectionView!.setCollectionViewLayout(self.hiddenLayout, animated: false)
    }
  }
  
  private func animationProducer(cells: [UICollectionViewCell], transform: CGAffineTransform) -> SignalProducer<(), NoError> {
    return SignalProducer<[UICollectionReusableView], NoError>(value: cells).flatMap(.latest, { cells -> SignalProducer<(), NoError> in
      let countingProducer = SignalProducer<TimeInterval, NoError>(value: 1).repeat(cells.count).scan(0, +)
      
      return SignalProducer(cells).zip(with: countingProducer).flatMap(.merge) { (cell, index) -> SignalProducer<(), NoError> in
        return SignalProducer<(), NoError> { observer, _ in
          UIView.animate(withDuration: 1.0,
                         delay: interval*index,
                         usingSpringWithDamping: 0.7,
                         initialSpringVelocity: 0.0,
                         animations: {
                          cell.transform = transform
          }, completion: { (success) in
            observer.sendCompleted()
          })
        }
      }
    })
  }
  
  open override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    finishHidingCells()
  }
}
