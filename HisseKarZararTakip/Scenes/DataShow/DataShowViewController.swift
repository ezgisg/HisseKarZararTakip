//
//  DataShowViewController.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 15.05.2024.
//

import UIKit

//TODO: Animation will be added

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
        return viewModel.sumRecordedShares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(cellType: ShareCollectionViewCell.self, indexPath: indexPath)
        cell.configure(with: viewModel.sumRecordedShares[indexPath.row])
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension DataShowViewController:  UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1) {
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            
            UIView.animate(withDuration: 0.1) {
                cell.transform = CGAffineTransform.identity
            } completion: { _ in
                guard let shareName = self.viewModel.sumRecordedShares[indexPath.row].name else { return }
                let detailVC = DetailViewController()
                detailVC.viewModel = DetailViewModel(name: shareName)
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            
        }
    }

}

// MARK: - Actions
private extension DataShowViewController {
    
   final func setupNavigationBar() {
        navigationItem.title = "Hisselerim Özet"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        let rightBarButton = UIBarButtonItem(title: "Tüm Kayıtlar", style: .plain, target: self, action: #selector(goToNextScreen))
            navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func goToNextScreen() {
         let recordsViewController = RecordedDataViewController()
         navigationController?.pushViewController(recordsViewController, animated: true)
     }
    
    final func collectionvViewConfiguration() {
        collectionView.dataSource = self
        collectionView.delegate = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(cellType: ShareCollectionViewCell.self)
    }
    
}
