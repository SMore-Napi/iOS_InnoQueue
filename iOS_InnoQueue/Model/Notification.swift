//
//  Notification.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 20.04.2022.
//

import Foundation

struct Notification {
    let message: String
    let timestamp: String
    
    init(message: String, timestamp: String){
        self.message = message
        self.timestamp = timestamp
    }
}
