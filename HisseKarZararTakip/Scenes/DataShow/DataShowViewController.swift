//
//  DataShowViewController.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 15.05.2024.
//

import UIKit

class DataShowViewController: UIViewController {

    let viewModel = DataShowViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchShares()
      
    }
    
}

extension DataShowViewController: DataShowViewModelDelegate {
    func getShares() {
        
    }
    

}
