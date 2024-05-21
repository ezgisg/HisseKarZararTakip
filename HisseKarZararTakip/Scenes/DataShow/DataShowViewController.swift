//
//  DataShowViewController.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 15.05.2024.
//

import UIKit

class DataShowViewController: UIViewController {
    
    // MARK: - Variables
    var collectionViewWidth = CGFloat()
    let viewModel = DataShowViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        collectionvViewConfiguration()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.calculateTotal()
    }
    

}

// MARK: - DataShowViewModelDelegate
extension DataShowViewController: DataShowViewModelDelegate {
    func getShares() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension DataShowViewController:  UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sumRecordedShares?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(cellType: ShareCollectionViewCell.self, indexPath: indexPath)
        cell.configure(data: viewModel.sumRecordedShares?[indexPath.row])
        return cell
    }
}

// MARK: - Actions
private extension DataShowViewController {
    
   final func setupNavigationBar() {
        navigationItem.title = "Hisselerim"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        let rightBarButton = UIBarButtonItem(title: "Detail", style: .plain, target: self, action: #selector(goToNextScreen))
            navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func goToNextScreen() {
         let secondViewController = RecordedDataViewController()
         navigationController?.pushViewController(secondViewController, animated: true)
     }
    
    final func collectionvViewConfiguration() {
        collectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(cellType: ShareCollectionViewCell.self)
    }
    
}
