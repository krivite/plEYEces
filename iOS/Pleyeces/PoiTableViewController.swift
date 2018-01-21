//
//  PoiTableViewController.swift
//  Pleyeces
//
//  Created by Filip Aleksić on 20/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import UIKit

class PoiTableViewController: UITableViewController, UISearchResultsUpdating {

    //MARK: Properties
    var pois = [PointOfInterest]()
    var filteredPois = [PointOfInterest]()
    var type: PoiType = PoiType()
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredPois = pois.filter({( poi : PointOfInterest) -> Bool in
            return poi.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        POIFetcher.fetchByType(typeId: type.id, success: { (pois) in
            self.pois = pois
            self.tableView.reloadData()
        })
        
        self.title = type.name
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search POIs"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredPois.count
        }
        return pois.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "PoiTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer,
                                                       for: indexPath) as? PoiTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PoiTableViewCell.")
        }

        // Configure the cell...
        let poi: PointOfInterest
        if isFiltering() {
            poi = filteredPois[indexPath.row]
        } else {
            poi = pois[indexPath.row]
        }
        
        cell.nameLabel.text = poi.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let poi: PointOfInterest
        if isFiltering() {
            poi = filteredPois[indexPath.row]
        } else {
            poi = pois[indexPath.row]
        }
        let destinationViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewScreen")  as! POIDetailViewController
        destinationViewController.poi = poi
        destinationViewController.hideButton = true;
        navigationController?.pushViewController(destinationViewController, animated: true)
    }

}
