//
//  UICollectionView+Extensions.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 17.05.2024.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func register(cellType: UICollectionViewCell.Type) {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.identifier)
    }
    
    func dequeCell<T: UICollectionViewCell>(cellType: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Hata meydana geldi")
        }
        
        return cell
    }
}
