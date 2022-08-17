//
//  AlbumViewController.swift
//  itunesTest
//
//  Created by admin on 13.08.2022.
//

import UIKit

class AlbumViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    

    

}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension AlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        return cell
    }
    
    
}
