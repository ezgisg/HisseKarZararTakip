//
//  DetailViewController.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 23.05.2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var shareNameLabel: UILabel!
    @IBOutlet weak var firstTradeDateStringLabel: UILabel!
    @IBOutlet weak var currentMarketPriceLabel: UILabel!
    @IBOutlet weak var marketDayLowLabel: UILabel!
    @IBOutlet weak var marketDayHighLabel: UILabel!
    @IBOutlet weak var previousCloseLabel: UILabel!
    
    var viewModel: DetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAndFillData()
    }

}

private extension DetailViewController {
    
    final func setupNavigationBar() {
        navigationItem.title = "Hisse Detay"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance

    }
    
    final func getAndFillData() {
        guard let shareName = viewModel?.name else { return }
        viewModel?.getShareDetail(selectedShare: shareName, completion: { [weak self] detailData in
            guard let self else { return }
            shareNameLabel.text = shareName
            guard let detailData else {
                showAlert(title: "Geçersiz Hisse", message: "Bu hisseye ait güncel bilgi bulunmuyor") {
                    self.navigationController?.popViewController(animated: true)
                }
                return }
            firstTradeDateStringLabel.text = detailData.firstTradeDateString ?? ""
            currentMarketPriceLabel.text = String(detailData.regularMarketPrice ?? 0)
            marketDayLowLabel.text = String(detailData.regularMarketDayLow ?? 0)
            marketDayHighLabel.text = String(detailData.regularMarketDayHigh ?? 0)
            previousCloseLabel.text = String(detailData.previousClose ?? 0)
        })
    }
    
}
