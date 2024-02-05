//
//  Team.swift
//  NBATeamsAPI
//
//  Created by Антон Баландин on 30.01.24.
//

import Foundation

struct Team: Decodable {
    let city: String
    let fullName: String
    let name: String
}

struct Game: Decodable {
    let date: String
    let season: Int
    let homeTeam: Team
    let homeTeamScore: Int
    let visitorTeam: Team
    let visitorTeamScore: Int
    
    var description: String {
        """
        Date: \(date)
        Season: \(season)
        \(homeTeam.name) - \(visitorTeam.name)
        \(homeTeam.city) - \(visitorTeam.city)
        \(homeTeamScore) - \(visitorTeamScore)
        """
    }
}

struct Games: Decodable {
    let data: [Game]
    
    static func getGames(from value: Any) -> [Game] {
        
        guard let gameDetails = value as? [String: Any] else { return []}
        guard let games = gameDetails["data"] as? [[String: Any]] else { return []}
        
        var gameData: [Game] = []
        
        for game in games {
            
            guard let homeTeam = game["home_team"] as? [String: Any] else { return []}
            guard let visitorTeam = game["visitor_team"] as? [String: Any] else { return []}
            
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
        
        return gameData
    }
}


