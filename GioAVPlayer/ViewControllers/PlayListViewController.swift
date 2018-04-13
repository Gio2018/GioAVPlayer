//
//  PlayListViewController.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/10/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import Pulley
import UIKit

class PlayListViewController: UIViewController {
    @IBOutlet weak var playListTableView: UITableView!
    @IBOutlet weak var playAllButton: UIButton!
    @IBOutlet weak var addMediaButton: UIButton!
    
    private var presenter: PlayListViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = PlayListViewPresenter(delegate: self)
        playListTableView.dataSource = self
        playListTableView.delegate = self
        configureUIItems()
    }
}

//  MARK: Actions
extension PlayListViewController {
    @IBAction func playAll(_ sender: Any) {
        presenter?.playMedia(at: 0)
    }
    
    @IBAction func addMedia(_ sender: Any) {
        guard let container = self.parent as? PulleyViewController else { return }
        container.presentGlobalMediaList()
    }
}


//  MARK UITableViewDataSource
extension PlayListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.librarySize ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PlayListCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MediaCell {
            cell.configureCell(arworkUrl: presenter?.mediaArtWorkUrl(at: indexPath.row) ?? "",
                               mediaTypeImageName: presenter?.mediaType(at: indexPath.row) ?? "unknown",
                               artistName: presenter?.artistName(at: indexPath.row) ?? "unknown",
                               mediaTitle: presenter?.mediaTitle(at: indexPath.row) ?? "unknown")
            return cell
        } else {
            return MediaCell()
        }
    }
    
    
}

//  MARK: UITableViewDelegate
extension PlayListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.playMedia(at: indexPath.row)
    }
}

//  MARK: Private helpers
extension PlayListViewController {
    
    /// Configures all buttons
    private func configureUIItems() {
        configurePlayAllButton()
        configureAddMediaButton()
    }
    
    /// Configures the "Play All" button
    private func configurePlayAllButton() {
        playAllButton.layer.cornerRadius = 4
        playAllButton.backgroundColor = UIColor.customLightGray
    }
    
    /// Configures the "Add Media" button
    private func configureAddMediaButton() {
        addMediaButton.layer.cornerRadius = 4
        addMediaButton.backgroundColor = UIColor.customLightGray
    }
    
    /// Opens the player view
    private func openPlayerView() {
        if let primaryController = self.parent as? PulleyViewController {
            primaryController.setDrawerPosition(position: .open, animated: true)
        }
    }
}

extension PlayListViewController: PlayListViewPresenterDelegate {
    func didRefreshPlayList() {
        DispatchQueue.main.async {
            self.playListTableView.reloadData()
        }
    }
    
    func startPlaying() {
        openPlayerView()
    }
}
