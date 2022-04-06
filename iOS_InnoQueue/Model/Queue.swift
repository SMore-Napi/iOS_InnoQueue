//
//  Queue.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 06.04.2022.
//

import Foundation

struct Queue: Equatable, Codable {
    let id: Int
    let name: String
    let color: String
    
    static let documentsDirectory =
        FileManager.default.urls(for: .documentDirectory,
        in: .userDomainMask).first!
    static let archiveURL =
       documentsDirectory.appendingPathComponent("queues")
       .appendingPathExtension("plist")
    
    init(id: Int, name: String, color: String) {
        self.id = id
        self.name = name
        self.color = color
    }
    
    static func ==(lhs: Queue, rhs: Queue) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func loadQueues() -> [Queue]?  {
        guard let codedQueues = try? Data(contentsOf: archiveURL) else
           {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Queue>.self,
           from: codedQueues)
    }
    
    static func loadSampleQueues() -> [Queue] {
        let queue1 = Queue(id: 1, name: "Trash", color: "GRAY")
        let queue2 = Queue(id: 2, name: "Bring Water", color: "BLUE")
        let queue3 = Queue(id: 3, name: "Buy Soap", color: "GREEN")
    
        return [queue1, queue2, queue3]
    }
    
    static func saveQueues(_ queues: [Queue]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedQueues = try? propertyListEncoder.encode(queues)
        try? codedQueues?.write(to: archiveURL, options: .noFileProtection)
    }
}
