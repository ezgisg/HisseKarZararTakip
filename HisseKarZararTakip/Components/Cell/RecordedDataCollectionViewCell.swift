//
//  RecordedDataCollectionViewCell.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 21.05.2024.
//

import UIKit

class RecordedDataCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var commissionLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func configure(with data: SavedShareModel?) {
        guard let data else { return }
        nameLabel.text = data.name
        countLabel.text = "Alınan hisse: \(data.count?.formatStringLikeInteger() ?? "")"
        priceLabel.text = "Satın alım fiyatı: \(data.price?.formatString() ?? "")"
        commissionLabel.text = "Komisyon tutarı: \(data.commission?.formatString() ?? "")"
        totalLabel.text = "Toplam maliyet: \(data.total?.formatString() ?? "")"
    }
}

private extension RecordedDataCollectionViewCell {
    final func setupUI() {
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 10
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    }
}
