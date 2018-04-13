//
//  MediaLibraryViewController.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/10/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import UIKit

class MediaLibraryViewController: UIViewController {
    
    @IBOutlet weak var mediaListTableView: UITableView!
    
    private var presenter: MediaLibraryViewPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MediaLibraryViewPresenter(delegate: self)
        mediaListTableView.dataSource = self
        mediaListTableView.delegate = self
        configureTableView()
    }
}

//  MARK: UI Configuration
extension MediaLibraryViewController {
    private func configureTableView() {
        mediaListTableView.estimatedRowHeight = 80
        mediaListTableView.rowHeight = UITableViewAutomaticDimension
        mediaListTableView.sectionFooterHeight = 0.0
    }
}

//  MARK: Actions
extension MediaLibraryViewController {
    @IBAction func closeMediaLibrary() {
        presenter?.dismiss()
    }
}

//  MARK: Presenter delegate
extension MediaLibraryViewController: MediaLibraryPresenterDelegate {
    func willDismissView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
}

//  MARK: UITableViewDataSource
extension MediaLibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.librarySize ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GlobalListCell"
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
extension MediaLibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.addMediaToPlayList(with: indexPath.row)
    }
}
