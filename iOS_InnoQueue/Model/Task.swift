//
//  Task.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 19.04.2022.
//

import Foundation

struct Task: Codable {
    let queue_id: Int
    let name: String
    let color: String
    let is_important: Bool
    let track_expenses: Bool
    
    init(queue_id: Int, name: String, color: String, is_important: Bool, track_expenses: Bool){
        self.queue_id = queue_id
        self.name = name
        self.color = color
        self.is_important = is_important
        self.track_expenses = track_expenses
    }
}
