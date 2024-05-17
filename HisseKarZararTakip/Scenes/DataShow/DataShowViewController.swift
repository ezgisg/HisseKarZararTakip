//
//  DataShowViewController.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 15.05.2024.
//

import UIKit

class DataShowViewController: UIViewController {
    
    var collectionViewWidth = CGFloat()
    let viewModel = DataShowViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: ShareCollectionViewCell.self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewWidth = collectionView.frame.width
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchShares()
        print(viewModel.allRecordedShares?.count ?? 0)
    }
    
}

extension DataShowViewController: DataShowViewModelDelegate {
    func getShares() {
        collectionView.reloadData()
    }

}


extension DataShowViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recordedSharesNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeCell(cellType: ShareCollectionViewCell.self, indexPath: indexPath)
        cell.configure(data: viewModel.sumRecordedShares?[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewWidth, height: 100)
    }
}
