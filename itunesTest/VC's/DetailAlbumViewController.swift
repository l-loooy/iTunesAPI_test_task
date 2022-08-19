//
//  DetailAlbumViewController.swift
//  itunesTest
//
//  Created by admin on 13.08.2022.
//

import UIKit

class DetailAlbumViewController: UIViewController {
    
    var album: Album?

    @IBOutlet weak var albumLogo: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var songsTableView: UITableView!
    
    private lazy var backendDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"

        return dateFormatter
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        return dateFormatter
    }()
    
    private var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setModel()
        fetchSongs(album: album)
        setBarButtonItem()
    }
    
    private func setModel() {
        guard let album = album else {
            return
        }
        
        albumTitle.text = album.collectionName
        artistName.text = album.artistName
        releaseDate.text = setDateFormatter(date: album.releaseDate)
        
        guard let url = album.artworkUrl100 else {
            return
        }
        
        setImage(urlString: url)
    }
    
    private func setDateFormatter(date: String) -> String {
        //"2021-05-14T07:00:00Z"
        //first get JSONDate
        guard let backendDate = backendDateFormatter.date(from: date) else {
            return ""
        }
        
        return dateFormatter.string(from: backendDate)
    }
    
    private func setImage(urlString: String?) {
        guard let logoUrl = urlString else {
            albumLogo.image = nil
            
            return
        }
        
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
    }
    
    private func fetchSongs(album: Album?) {
        guard let album = album else {
            return
        }
        
        let idAlbum = album.collectionId
        let urlString = "https://itunes.apple.com/lookup?id=\(idAlbum)&entity=song"
        
        NetworkDataFetch.shared.fetchSongs(urlString: urlString) { [weak self] songModel, error in
            if error == nil {
                guard let songModel = songModel else {
                    return
                }
                
                self?.songs = songModel.results
                self?.songsTableView.reloadData()
            } else {
                // add alert ibstead c кнопкой повтора запроса
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
            withIdentifier: "UserInfoViewController") as? UserInfoViewController else {
            return
        }
        
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
