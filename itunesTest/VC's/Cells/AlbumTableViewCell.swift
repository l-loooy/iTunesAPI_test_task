//
//  AlbumTableViewCell.swift
//  itunesTest
//
//  Created by admin on 17.08.2022.
//

import UIKit

final class AlbumTableViewCell: UITableViewCell {
    
    static let shared = AlbumTableViewCell()
    
    @IBOutlet weak var albumLogo: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func getAlbumLogoFrom(_ album: Album) {
        if let urlString = album.artworkUrl100 {
            NetworkRequest.shared.requestData(urlString: urlString) { [weak self] result in
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
}
