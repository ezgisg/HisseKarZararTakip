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
         guard let data = data else { return }
         
         shareName.text = data.name
        count.attributedText = attributedText(withTitle: "Adet: ", value: (data.count ?? 0).formatStringLikeInteger(), fontSize: 17)
        avgPrice.attributedText = attributedText(withTitle: "Ort. maliyet: ", value: (data.avgPrice ?? 0).formatString(), fontSize: 17)
        commission.attributedText = attributedText(withTitle: "Komisyon: ", value: (data.commission ?? 0).formatString(), fontSize: 17)
        total.attributedText = attributedText(withTitle: "Toplam maliyet: ", value: (data.total ?? 0).formatString(), fontSize: 17)
        currentPrice.attributedText = attributedText(withTitle: "Güncel fiyat: ", value: "\(data.currentPrice ?? 0)", fontSize: 17)
         
         let gain = (data.count ?? 0) * ((data.currentPrice ?? 0) - (data.avgPrice ?? 0))
         let gainWCommission = gain - (data.commission ?? 0)
        profit.attributedText = attributedText(withTitle: "Kar/zarar: ", value: gainWCommission.formatString(), fontSize: 24)
         profit.textColor = gainWCommission >= 0 ? .systemGreen : .red
     
     }

    private func attributedText(withTitle title: String, value: String, fontSize: Int) -> NSAttributedString {
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
    
    func setupUI() {
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 10
   
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        addVerticalDivider(to: mainStack)
  
    }
    
    func addVerticalDivider(to stackView: UIStackView, withHeight height: CGFloat = 1.0, color: UIColor = .black) {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: height).isActive = true
        divider.backgroundColor = color
        stackView.insertArrangedSubview(divider, at: 1)
        divider.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true

    }
    
  

}

