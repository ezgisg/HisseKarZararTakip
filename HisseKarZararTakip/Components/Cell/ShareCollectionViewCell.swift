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
}

extension ShareCollectionViewCell {
    func configure(with data: TotalShareModel?) {
        guard let data = data else { return }
        
        shareName.text = data.name
        count.attributedText = attributedText(title: "Adet: ", value: (data.count ?? 0).formatStringLikeInteger())
        avgPrice.attributedText = attributedText(title: "Ort. maliyet: ", value: (data.avgPrice ?? 0).formatString())
        commission.attributedText = attributedText(title: "Komisyon: ", value: (data.commission ?? 0).formatString())
        total.attributedText = attributedText(title: "Toplam maliyet: ", value: (data.total ?? 0).formatString())
        currentPrice.attributedText = attributedText(title: "Güncel fiyat: ", value: "\(data.currentPrice ?? 0)")
        
        let gain = (data.count ?? 0) * ((data.currentPrice ?? 0) - (data.avgPrice ?? 0))
        let gainWCommission = gain - (data.commission ?? 0)
        profit.attributedText = attributedText(title: "Kar/zarar: ", value: gainWCommission.formatString(), fontSize: 24)
        profit.textColor = gainWCommission >= 0 ? .systemGreen : .red
    }
}


private extension ShareCollectionViewCell {
    final func attributedText(title: String, value: String, fontSize: Int = 17) -> NSAttributedString {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: CGFloat(fontSize))
        ]
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: CGFloat(fontSize - 1))
        ]
        
        let attributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        let valueString = NSAttributedString(string: value, attributes: valueAttributes)
        attributedString.append(valueString)
        
        return attributedString
    }
    
    final func setupUI() {
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 10
        
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        addVerticalDivider(to: mainStack)
    }
    
    final func addVerticalDivider(to stackView: UIStackView, withHeight height: CGFloat = 1.0, color: UIColor = .black) {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = color
        stackView.insertArrangedSubview(divider, at: 1)
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: height),
            divider.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
  
    }
}

