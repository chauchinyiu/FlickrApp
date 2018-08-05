//
//  ViewController.swift
//  FlickrApp
//
//  Created by Chau Chin Yiu on 31/7/2018.
//  Copyright © 2018 Chau Chin Yiu. All rights reserved.
//
import UIKit
import LittleFramework

class PhotosBrowserViewController: UITableViewController,ViewModelDriven {
    typealias ViewModelType = PhotosBrowserViewModel
    var viewModel: ViewModelType! = ViewModelType()
    @IBOutlet weak var sortedReloadButtonItem: UIBarButtonItem!
    var inDescendingOrder : Bool = true {
        didSet{
            updateSortedReloadButtonItem()
        }
    }
    override func viewDidLoad() {
        
        self.viewModel.loadPhotos(inDescendingOrder)
        updateSortedReloadButtonItem()
        self.kittensCellViewModelsBinder <~ self.viewModel.kittensPhotosCollectionCellViewModels
        self.dogsCellViewModelsBinder <~ self.viewModel.dogsPhotosCollectionCellViewModels
        self.interestingCellViewModelsBinder <~ self.viewModel.interestingPhotosCollectionCellViewModels
        self.recentCellViewModelsBinder <~ self.viewModel.recentPhotosCollectionCellViewModels
    }
    
    private func updateSortedReloadButtonItem(){
        if inDescendingOrder == true {
            self.sortedReloadButtonItem.title = "🔄 Oldest Photos"
        }else {
             self.sortedReloadButtonItem.title = "🔄 Latest Photos"
        }
    }
    private(set) lazy var kittensCellViewModelsBinder: Binder<[PhotoCollectionViewCellViewModel]> = Binder<[PhotoCollectionViewCellViewModel]> {[unowned self] (cellViewModels) in
        DispatchQueue.main.async {
            if let cell: PhotosTableViewCell = self.tableView.cellForRow(at:Section.cats.sectionIndexPath) as? PhotosTableViewCell{
                cell.updateCollectionViewContent(viewModels:cellViewModels)
            }
        }
    }

    
    private(set) lazy var dogsCellViewModelsBinder: Binder<[PhotoCollectionViewCellViewModel]> = Binder<[PhotoCollectionViewCellViewModel]> {[unowned self] ( cellViewModels) in
        DispatchQueue.main.async {
            if let cell: PhotosTableViewCell = self.tableView.cellForRow(at: Section.dogs.sectionIndexPath) as? PhotosTableViewCell {
            cell.updateCollectionViewContent(viewModels:cellViewModels)
            }
            
        }
    }
    
    private(set) lazy var interestingCellViewModelsBinder: Binder<[PhotoCollectionViewCellViewModel]> = Binder<[PhotoCollectionViewCellViewModel]> {[unowned self] (cellViewModels) in
        DispatchQueue.main.async {
            if let cell: PhotosTableViewCell = self.tableView.cellForRow(at: Section.interesting.sectionIndexPath) as? PhotosTableViewCell{
                cell.updateCollectionViewContent(viewModels: cellViewModels)
            }
            
        }
    }
    private(set) lazy var recentCellViewModelsBinder: Binder<[PhotoCollectionViewCellViewModel]> = Binder<[PhotoCollectionViewCellViewModel]> {[unowned self] (cellViewModels) in
        DispatchQueue.main.async {
            if let cell: PhotosTableViewCell = self.tableView.cellForRow(at:Section.recent.sectionIndexPath) as? PhotosTableViewCell{
              cell.updateCollectionViewContent(viewModels: cellViewModels)
            }
        }
    }
    @IBAction func refreshButtonPressed(_ sender: Any){
         inDescendingOrder = !inDescendingOrder
         viewModel.loadPhotos(inDescendingOrder)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.numberOfSections
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return Section.init(rawValue: section)?.sectionTitle
       
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PhotosTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PhotosTableViewCell", for: indexPath) as! PhotosTableViewCell
          cell.updateCollectionViewContent(viewModels: viewModel.retrieveLoadedPhotoCollectionViewCellViewModels(section: indexPath.section))
        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let cell :PhotoCollectionViewCell = sender as? PhotoCollectionViewCell,
            let _ = cell.cellViewModel {
            return true
        }
        return false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell:PhotoCollectionViewCell = sender as? PhotoCollectionViewCell,
             let viewController =  segue.destination as? PhotoDetailViewController,
            let cellViewModel = cell.cellViewModel {
            
            viewController.viewModel = PhotoDetailViewModel(collectionViewCellViewModel: cellViewModel)
        }
    }
    
    
}


