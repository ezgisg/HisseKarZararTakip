//
//  RecordedDataViewController.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 21.05.2024.
//

import UIKit

class RecordedDataViewController: UIViewController {

    //TO DO: breaking constraint ler düzeltilecek
    //TO DO: ekranda alfabetik sıralama ile sıralanması sağlanacak
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var deleteButton = UIBarButtonItem()
    var editButton = UIBarButtonItem()
    let viewModel = RecordedDataViewModel()
    var selectedCellsUUID = Set<UUID>() {
        didSet {
            selectedCount = selectedCellsUUID.count
        }
    }
    var selectedCount: Int = 0 {
        didSet {
            updateButtonStates()
        }
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupNavigationBar()
        setupSearchBar()
        collectionViewConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getAllShares()
    }
    
}

// MARK: - UICollectionViewDataSource
extension RecordedDataViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredRecordedShares?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(cellType: RecordedDataCollectionViewCell.self, indexPath: indexPath)
        cell.configure(data: viewModel.filteredRecordedShares?[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RecordedDataViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let uuid = viewModel.filteredRecordedShares?[indexPath.row].uuid,
              let cell = collectionView.cellForItem(at: indexPath) else { return }
            if cell.contentView.backgroundColor == .lightGray {
                selectedCellsUUID.remove(uuid)
                cell.contentView.backgroundColor = .white
            } else {
                selectedCellsUUID.insert(uuid)
                cell.contentView.backgroundColor = .lightGray
            }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let uuid = viewModel.filteredRecordedShares?[indexPath.row].uuid else { return }
        if selectedCellsUUID.contains(uuid){
            cell.contentView.backgroundColor = .lightGray
        } else {
            cell.contentView.backgroundColor = .white
        }
    }
    
}

// MARK: - RecordedDataViewModelDelegate
extension RecordedDataViewController: RecordedDataViewModelDelegate {
 
    func filterWithSearchText() {
        viewModel.filterAfterUpdateShare(searchText: searchBar.text)
    }
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    func getRecords() {
//        collectionView.reloadSections([0])
        selectedCellsUUID.removeAll(keepingCapacity: false)
        collectionView.reloadData()
    }
    
}

// MARK: - Setup Functions for Screen Components
private extension RecordedDataViewController {
    final func setupNavigationBar() {
        navigationItem.title = "Tüm Kayıtlar"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        
        let deleteIcon = UIImage(systemName: "trash")
        let editIcon = UIImage(systemName: "pencil")
        deleteButton = UIBarButtonItem(image: deleteIcon, style: .plain, target: self, action: #selector(deleteTapped))
        editButton = UIBarButtonItem(image: editIcon, style: .plain, target: self, action: #selector(editTapped))
        navigationItem.rightBarButtonItems = [deleteButton, editButton]
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

// MARK: - Actions
private extension RecordedDataViewController {
    
    @objc final func deleteTapped() {
        var selectedShareModels = [SavedShareModel]()
        for selectedCellUUID in selectedCellsUUID {
            guard let shareModel = viewModel.filteredRecordedShares?.first(where: { $0.uuid == selectedCellUUID}) else { return }
            selectedShareModels.append(shareModel)
        }
        viewModel.deleteShares(shares: selectedShareModels)
    }
    
    @objc final func editTapped() {
        guard let selectedCellUUID = selectedCellsUUID.first,
              let shareModel = viewModel.filteredRecordedShares?.first(where: { $0.uuid == selectedCellUUID}) else { return }
        let message = "Kaydı değiştirmek için yeni değerleri giriniz"
        getDataAlert(model: shareModel, message: message) { updatedShare in
            self.viewModel.updateShare(uuid: updatedShare.uuid, newCount: updatedShare.newCount, newPrice: updatedShare.newPrice, newCommission: updatedShare.newCommission)
        }
    }
    
    final func updateButtonStates() {
        viewModel.controlSelectedCountandChangeButtonStatus(count: selectedCount) { buttonStatus in
            guard let isEditButtonEnabled = buttonStatus.isEditButtonEnabled,
                  let isDeleteButtonEnabled = buttonStatus.isDeleteButtonEnabled else { return }
            editButton.isEnabled = isEditButtonEnabled
            deleteButton.isEnabled = isDeleteButtonEnabled
        }
    }
    
    final func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Arama için en az 4 karakter giriniz."
    }
    
}

// MARK: - UISearchBarDelegate
extension RecordedDataViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterRecordsWithWhenSearchTextChanged(searchText: searchText)
    }
}

