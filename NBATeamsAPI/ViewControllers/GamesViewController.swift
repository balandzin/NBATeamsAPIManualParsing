//
//  ViewController.swift
//  NBATeamsAPI
//
//  Created by Антон Баландин on 30.01.24.
//

import UIKit

final class GamesViewController: UITableViewController {
    
    /*
     API (сведения об играх команд NBA)
     находится по адресу https://www.balldontlie.io/home.html#introduction
     */
    
    private var games: Games!
    private var gameData: [Game] = []
    private let networkManager = NetworkManager.shared
    private let url = "https://www.balldontlie.io/api/v1/games"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        //showSpinner(in: view)
        fetchGames()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gameData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
        let game = gameData[indexPath.row]
        cell.configure(with: game)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let detailsVC = segue.destination as? GameDetailsViewController
        detailsVC?.game = gameData[indexPath.row]
    }
}

// MARK: - Networking
extension GamesViewController {
    private func fetchGames() {
        networkManager.fetchGames(from: url) { [unowned self] result in
            switch result {
            case .success(let games):
                self.gameData = games
                self.tableView.reloadData()
            case .failure(let error):
                showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
        
    }
    
    private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }
}
