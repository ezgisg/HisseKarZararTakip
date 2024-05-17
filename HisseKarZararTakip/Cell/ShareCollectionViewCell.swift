//
//  ShareCollectionViewCell.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 17.05.2024.
//

import UIKit

class ShareCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shareName: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var avgPrice: UILabel!
    @IBOutlet weak var commission: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var total: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
    }

    
    func configure(data: SavedShareModel?) {
        guard let data = data else {return}
        shareName.text = data.name
        count.text = String(data.count ?? 0)
        avgPrice.text = String(data.price ?? 0)
        commission.text = String(data.commission ?? 0)
        total.text = String(data.total ?? 0)
    }
    
    func setupUI() {
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.cornerRadius = 5
        containerView.layer.cornerRadius = 5
    }
}
