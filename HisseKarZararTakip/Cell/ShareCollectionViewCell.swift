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
    @IBOutlet weak var profit: UILabel!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var subStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
    }

    
    func configure(data: TotalShareModel?) {
        guard let data = data else {return}
        shareName.text = data.name
        count.text = "Hisse adedi: \(data.count ?? 0)"
        avgPrice.text = "Ortalama maliyet: \((data.avgPrice ?? 0).formatString())"
        commission.text = "Komisyon: \((data.commission ?? 0).formatString())"
        total.text = "Toplam harcanan: \((data.total ?? 0).formatString())"
        currentPrice.text = "Güncel hisse fiyatı: \(data.currentPrice ?? 0)"
        
        let gain = (data.count ?? 0) * ((data.currentPrice ?? 0) - (data.avgPrice ?? 0))
        let gainWCommission = gain - (data.commission ?? 0)
        profit.text = "Kar/zarar: \(gainWCommission.formatString())"
        if gainWCommission >= 0 {
            profit.textColor = .systemGreen
        } else {
            profit.textColor = .red
        }
    }
    
    func setupUI() {
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 10
  
    }
    
   
}

