//
//  NetowrkRequestsController.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 12.04.2022.
//

import Foundation

class QueueShortRequest {
    
    static func loadQueues() -> [Queue]? {
        
        var loadedQueues = [Queue]()
        
        let sem = DispatchSemaphore.init(value: 0)
                
        let url = URL(string: "https://innoqueue.herokuapp.com/queues")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            defer { sem.signal() }
            
            if let _error = error {
                // Handle HTTP request error
            } else if let data2 = data {
                // Handle HTTP request response

                let jsonDecoder = JSONDecoder()
                do {
                let parsedJSON = try jsonDecoder.decode(QueuesJSON.self, from: data2)
                    for queue in parsedJSON.active {
                        let q = Queue(id: queue.id, name: queue.name, color: queue.color)
                        loadedQueues.append(q)
                    }
                    for queue in parsedJSON.frozen {
                        let q = Queue(id: queue.id, name: queue.name, color: queue.color)
                        loadedQueues.append(q)
                    }
                }
                catch {
                    print(error)
               }
            } else {
                // Handle unexpected error
            }
        }
        
        task.resume()
        
        sem.wait()
    
        return loadedQueues
    }
    
    static func createQueue(queue: QueueCreateJSON) {
        
        print("hahah")
        print(queue)
            
        let url = URL(string: "https://innoqueue.herokuapp.com/queues")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let jsonData = try JSONEncoder().encode(queue)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    // Handle HTTP request error
                } else if let data = data {
                    // Handle HTTP request response
                } else {
                    // Handle unexpected error
                }
            }
            task.resume()
                
        } catch {
        }
    }
    
    static func loadQueueById(id: Int) -> QueueFullJSON {
        
        let sem = DispatchSemaphore.init(value: 0)
                
        let url = URL(string: "https://innoqueue.herokuapp.com/queues/\(id)")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        
        var loadedQueue: QueueFullJSON? = nil
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            defer { sem.signal() }
            
            if let _error = error {
                // Handle HTTP request error
            } else if let data = data {
                // Handle HTTP request response

                let jsonDecoder = JSONDecoder()
                do {
                let parsedJSON = try jsonDecoder.decode(QueueFullJSON.self, from: data)
                    loadedQueue = QueueFullJSON(id: parsedJSON.id, name: parsedJSON.name, color: parsedJSON.color, on_duty: parsedJSON.on_duty, is_on_duty: parsedJSON.is_on_duty, participants: parsedJSON.participants, track_expenses: parsedJSON.track_expenses, is_active: parsedJSON.is_active, is_admin: parsedJSON.is_admin)
                }
                catch {
                    print(error)
               }
            } else {
                // Handle unexpected error
            }
        }
        
        task.resume()
        
        sem.wait()
    
        return loadedQueue!
    }
}
