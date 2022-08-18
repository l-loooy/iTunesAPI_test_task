//
//  AlbumViewController.swift
//  itunesTest
//
//  Created by admin on 13.08.2022.
//

import UIKit

class AlbumViewController: UIViewController {
    
    var timer: Timer?
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    var albums = [Album]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupSearchController()
        setupNavigationBar()
        
        tableView.rowHeight = 65
        
    }
    
   
    
    
    private func fetchAlbums(albumName: String) {
        let urlString = "https://itunes.apple.com/search?term=\(albumName)&entity=album&attribute=albumTerm"
        
        NetworkDataFetch.shared.fetchAlbums(urlString: urlString) { [weak self] albumModel, error in
            if error == nil {
                guard let albumModel = albumModel else { return }
                self?.albums = albumModel.results
                print(self?.albums)
                self?.tableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchBar.delegate = self
    }

    private func setupSearchController() {
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Albums"
        navigationItem.searchController = searchController
    }
    
}


//MARK: - SearchController
extension AlbumViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                self?.fetchAlbums(albumName: searchText)
            })
        }
    }
}






//MARK: - UITableViewDelegate, UITableViewDataSource

extension AlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! AlbumTableViewCell
        let album = albums[indexPath.row]
        
        cell.artistName.text = album.artistName
        cell.albumTitle.text = album.collectionName
        cell.trackCount.text = "Songs: \(album.trackCount)"
        cell.getAlbumLogoFrom(album)
        

        return cell
    }
    
    
}
