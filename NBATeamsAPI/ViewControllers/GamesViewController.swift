//
//  ViewController.swift
//  NBATeamsAPI
//
//  Created by Антон Баландин on 30.01.24.
//

import UIKit
import Alamofire

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
        AF.request(url)
            .validate()
            .responseJSON { [unowned self] dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    
                    guard let gameDetails = value as? [String: Any] else { return }
                    
                    guard let games = gameDetails["data"] as? [[String: Any]] else { return }
                    
                    for game in games {
                        
                        guard let homeTeam = game["home_team"] as? [String: Any] else { return }
                        guard let visitorTeam = game["visitor_team"] as? [String: Any] else { return }
                        
                        let game = Game(
                            date: game["date"] as? String ?? "",
                            season: game["season"] as? Int ?? 0,
                            homeTeam: Team(
                                city: homeTeam["city"] as?  String ?? "",
                                fullName: homeTeam["full_name"] as? String ?? "",
                                name: homeTeam["name"] as? String ?? ""
                                ),
                            homeTeamScore: game["home_team_score"] as? Int ?? 0,
                            visitorTeam: Team(
                                city: visitorTeam["city"] as? String ?? "",
                                fullName: visitorTeam["full_name"] as? String ?? "",
                                name: visitorTeam["name"] as? String ?? ""
                                ),
                            visitorTeamScore: game["visitor_team_score"] as? Int ?? 0
                            )
                        gameData.append(game)
                    }
                    
                    print(games)
                    tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
}
