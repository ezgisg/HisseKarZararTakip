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
    
    }
    
    override func viewDidLayoutSubviews() {
        viewModel.fetchShares()
      
        print(self.viewModel.recordedShares,"hey")
        

    }
    

}

extension DataShowViewController: DataShowViewModelDelegate {
    
}
