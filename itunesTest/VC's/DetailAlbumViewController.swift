//
//  DetailAlbumViewController.swift
//  itunesTest
//
//  Created by admin on 13.08.2022.
//

import UIKit

class DetailAlbumViewController: UIViewController {

    var album: Album?
    var songs = [Song]()
    
    @IBOutlet weak var albumLogo: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var songsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setModel()
        fetchSongs(album: album)
        setBarButtonItem()
        
        
    }
    
    
    private func setModel() {
        guard let album = album else { return }
        albumTitle.text = album.collectionName
        artistName.text = album.artistName
        releaseDate.text = setDateFormatter(date: album.releaseDate)
        
        guard let url = album.artworkUrl100 else { return }
        setImage(urlString: url)
        
        
        
    }
    
    private func setDateFormatter(date: String) -> String {
        //"2021-05-14T07:00:00Z"
        //first get JSONDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"
        guard let backendDate = dateFormatter.date(from: date) else { return "" }
        
        //convert it to our format dd-MM-yyyy
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy"
        let date = formatDate.string(from: backendDate)
        return date
        
        
    }
    
    
    private func setImage(urlString: String?) {
        
        if let logoUrl = urlString {
            
            NetworkRequest.shared.requestData(urlString: logoUrl) { [weak self] result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    self?.albumLogo?.image = image
                    print("ALBUM LOGO SUCCESS")
                case .failure(_):
                    self?.albumLogo.image = nil
                    print("ALBUM LOGO ERROR")
                }
            }
        } else {
            albumLogo.image = nil
        }
    }
    
    private func fetchSongs(album: Album?) {
        
        guard let album = album else { return }
        let idAlbum = album.collectionId
        let urlString = "https://itunes.apple.com/lookup?id=\(idAlbum)&entity=song"
        
        
        NetworkDataFetch.shared.fetchSongs(urlString: urlString) { [weak self] songModel, error in
            if error == nil {
                guard let songModel = songModel else { return }
                self?.songs = songModel.results
                self?.songsTableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    
    private func setBarButtonItem() {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"),
                                            style: .done,
                                            target: self,
                                            action: #selector(showUserInfo))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func showUserInfo() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let userInfoVC = storyboard.instantiateViewController(
            withIdentifier: "UserInfoViewController") as? UserInfoViewController else { return }
        
        self.navigationController?.pushViewController(userInfoVC, animated: true)
    }

}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension DetailAlbumViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupDelegate() {
        songsTableView.delegate = self
        songsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songsCell", for: indexPath)
        let song = songs[indexPath.row].trackName
        
        var content = cell.defaultContentConfiguration()
        content.text = song
        cell.contentConfiguration = content
        
        return cell
        
    }
}
