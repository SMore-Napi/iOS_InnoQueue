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

struct CompleteTaskJSON: Codable {
    let task_id: Int
    let expenses: Int?
}

struct ToDoTaskJSON: Codable {
    let queue_id: Int
    let name: String
    let color: String
    let is_important: Bool
    let track_expenses: Bool
}

struct SkipTaskJSON: Codable {
    let task_id: Int
}

struct InivteCodeJSON: Codable {
    let pin_code: String?
    let qr_code: String?
}

struct NotificationsJSON: Codable {
    let unread: [MessageJSON]
    let all: [MessageJSON]
}

struct MessageJSON: Codable {
    let message: String
    let timestamp: String
}

struct SettingsJSON: Codable {
    let name: String
    let n1: Bool
    let n2: Bool
    let n3: Bool
    let n4: Bool
    let n5: Bool
}
