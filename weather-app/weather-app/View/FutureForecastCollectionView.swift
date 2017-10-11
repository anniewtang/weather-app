//
//  FutureForecastCollectionView.swift
//  weather-app
//
//  Created by Annie Tang on 10/10/17.
//  Copyright © 2017 Annie Tang. All rights reserved.
//

import UIKit

/* EXTENSION OF COLLECTIONVIEW */
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /* number of types of cells in collectionView */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /* number of cells in a section */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return futureForecasts.count
    }
    
    /* dequeue & setting up collectionView cell
     sets the pokemon's image, name to the collectionView cell */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /* dequeue cell and remove/reset from subview; initialize new cell */
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! FutureForecastCollectionCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        return cell
    }
    
    /* makes it such that the cells are 1/4 of the view width square */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65.8, height: 111)
    }
}

