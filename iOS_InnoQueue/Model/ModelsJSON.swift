//
//  ModelsJSON.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 12.04.2022.
//

import Foundation

struct QueuesJSON: Codable {
    let active: [QueueShortJSON]
    let frozen: [QueueShortJSON]
}

struct QueueShortJSON: Codable {
    let id: Int
    let name: String
    let color: String
}

struct QueueCreateJSON: Codable {
    let name: String
    let color: String
    let track_expenses: Bool
}

struct UserQueue: Codable {
    let user_id: Int
    let user: String
    let expenses: Int
    let is_active: Bool
}

struct QueueFullJSON: Codable {
    let id: Int
    let name: String
    let color: String
    let on_duty: UserQueue
    let is_on_duty: Bool
    let participants: [UserQueue]
    let track_expenses: Bool
    let is_active: Bool
    let is_admin: Bool
}
