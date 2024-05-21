//
//  RecordedDataViewController.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 21.05.2024.
//

import UIKit

class RecordedDataViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
 
    let viewModel = RecordedDataViewModel()
    var selectedCells = Set<IndexPath>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupNavigationBar()
        collectionViewConfiguration()
   
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchShares()

    }

}

// MARK: - UICollectionViewDataSource

extension RecordedDataViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allRecordedShares?.count ?? 0
     
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeCell(cellType: RecordedDataCollectionViewCell.self, indexPath: indexPath)
        cell.configure(data: viewModel.allRecordedShares?[indexPath.row])
        return cell
      
    }
}

// MARK: - UICollectionViewDelegate
extension RecordedDataViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            if cell.contentView.backgroundColor == .lightGray {
                cell.contentView.backgroundColor = .white
                selectedCells.remove(indexPath)
                viewModel.deleteShares(share: viewModel.allRecordedShares?[indexPath.row])
            } else {
                cell.contentView.backgroundColor = .lightGray
                selectedCells.insert(indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if selectedCells.contains(indexPath) {
            cell.contentView.backgroundColor = .lightGray
        } else {
            cell.contentView.backgroundColor = .white
        }
    }
    
}

// MARK: - RecordedDataViewModelDelegate

extension RecordedDataViewController: RecordedDataViewModelDelegate {
   
    func getRecords() {
//        collectionView.reloadSections([0])
        collectionView.reloadData()
    }
    
}

// MARK: - Navigation Bar and Collection View Arrangaments
private extension RecordedDataViewController {
    final func setupNavigationBar() {
        navigationItem.title = "Kayıtlarım"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    final func collectionViewConfiguration() {
        collectionView.dataSource = self
        collectionView.delegate = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: 128
        )
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(cellType: RecordedDataCollectionViewCell.self)
    }
}
