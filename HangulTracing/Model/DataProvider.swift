//
//  DataProvider.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

enum CellMode: Int {
  case normal
  case delete
}

class DataProvider: NSObject {
  var cardManager: CardManager?
  var cellMode: CellMode = .normal
  var audioPlayer = SoundPlayer()
}

extension DataProvider: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let cardManager = cardManager else { fatalError() }
    return cardManager.toDoCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cardManager = cardManager else { fatalError() }
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCardCell", for: indexPath) as? WordCardCell {
      cell.configCell(card: cardManager.cardAt(index: indexPath.item), cellMode: cellMode)
      cell.deleteBtnDelegate = collectionView.parentViewController as? CardListVC
      return cell
    } else {
      return WordCardCell()
    }
  }
}

extension DataProvider: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cardManager = cardManager else { fatalError() }
    guard let parentVC = collectionView.parentViewController as? CardListVC else { fatalError() }
    audioPlayer.playSoundEffect(name: "open", extender: "wav")
    let cell = collectionView.cellForItem(at: indexPath) as! WordCardCell
    parentVC.setSelectedCell(cell: cell)
    let imgHeight = cell.imgView.bounds.height
    let imgWidth = cell.imgView.bounds.width
    let viewWidth = UIScreen.main.bounds.width - 100
    let viewHeight = imgHeight * viewWidth / imgWidth
    let centerX = UIScreen.main.bounds.width / 2
    let centerY = UIScreen.main.bounds.height / 2

    let cellVC = CellVC(viewFrame: CGRect(x: centerX - viewWidth / 2, y: centerY - viewHeight / 2, width: viewWidth, height: viewHeight))
    cellVC.setInit(index: indexPath.item, vc: parentVC, manager: cardManager)
    cellVC.configView(card: cardManager.cardAt(index: indexPath.item))
    cellVC.transitioningDelegate = parentVC as! UIViewControllerTransitioningDelegate
    
    parentVC.present(cellVC, animated: true) {
      cellVC.flip(completion: { (success) in
      })
    }
  }
}

extension DataProvider: PinterestLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    guard let cardManager = cardManager else { fatalError() }
    let imgData =  cardManager.cardAt(index: indexPath.item).imgData
    guard let image = UIImage(data: imgData) else { return 0 }
    let ratio = image.size.width / image.size.height
    let leftRightInset: CGFloat = 20.0
    let cellPadding: CGFloat = 6.0
    let numberOfColumn: CGFloat = 2.0
    let cellWidth = (UIScreen.main.bounds.width - leftRightInset - cellPadding) / numberOfColumn
    
    return cellWidth / ratio
  }
}
