//
//  DataShowViewController.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 15.05.2024.
//

import UIKit

class DataShowViewController: UIViewController {
    
    var cellHeights: [IndexPath: CGFloat] = [:]
    
    var collectionViewWidth = CGFloat()
    let viewModel = DataShowViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(cellType: ShareCollectionViewCell.self)
        setupNavigationBar()


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewWidth = collectionView.frame.width
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.calculateTotal()
    
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Hisselerim"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
    }
}

extension DataShowViewController: DataShowViewModelDelegate {
    func getShares() {
        collectionView.reloadData()
       
    }

}


extension DataShowViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sumRecordedShares?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeCell(cellType: ShareCollectionViewCell.self, indexPath: indexPath)
        cell.configure(data: viewModel.sumRecordedShares?[indexPath.row])
        return cell
    }
 

}
