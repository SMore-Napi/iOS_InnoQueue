//
//  NetowrkRequestsController.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 12.04.2022.
//

import Foundation

let baseURL = "https://innoqueue.herokuapp.com"

class QueueShortRequest {
    
    static let pathURL = "/queues"
    
    static func loadQueues() -> ([Queue]?, [Queue]?) {
        
        var activeQueues = [Queue]()
        var frozenQueues = [Queue]()
        
        let sem = DispatchSemaphore.init(value: 0)
                
        let url = URL(string: "\(baseURL)\(pathURL)")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            defer { sem.signal() }
            
            if let _error = error {
                // Handle HTTP request error
            } else if let data = data {
                // Handle HTTP request response

                let jsonDecoder = JSONDecoder()
                do {
                let parsedJSON = try jsonDecoder.decode(QueuesJSON.self, from: data)
                    for queue in parsedJSON.active {
                        let q = Queue(id: queue.id, name: queue.name, color: queue.color)
                        activeQueues.append(q)
                    }
                    for queue in parsedJSON.frozen {
                        let q = Queue(id: queue.id, name: queue.name, color: queue.color)
                        frozenQueues.append(q)
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
    
        return (activeQueues, frozenQueues)
    }
    
    static func createQueue(queue: QueueCreateJSON) {
            
        let url = URL(string: "\(baseURL)\(pathURL)")!
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
                
        let url = URL(string: "\(baseURL)\(pathURL)/\(id)")!
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
    
    static func shakeUser(queue_id: Int) {
            
        let url = URL(string: "\(baseURL)\(pathURL)/shake/\(queue_id)")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
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
    
    static func inviteInQueueById(id: Int) -> (String?, String?) {
        
        let sem = DispatchSemaphore.init(value: 0)
                
        let url = URL(string: "\(baseURL)\(pathURL)/invite/\(id)")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        
        var pinCode: String? = nil
        var qrCode: String? = nil
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            defer { sem.signal() }
            
            if let _error = error {
                // Handle HTTP request error
            } else if let data = data {
                // Handle HTTP request response

                let jsonDecoder = JSONDecoder()
                do {
                let parsedJSON = try jsonDecoder.decode(InivteCodeJSON.self, from: data)
                    pinCode = parsedJSON.pin_code
                    qrCode = parsedJSON.qr_code
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
    
        return (pinCode, qrCode)
    }
    
    static func joinQueue(pinCode: String? = nil, qrCode: String? = nil) -> Int? {
        
        print("initial")
        print(pinCode)
        print(qrCode)
        
        var idToToReturn: Int? = nil
        
        let sem = DispatchSemaphore.init(value: 0)
            
        let url = URL(string: "\(baseURL)\(pathURL)/join")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            print("aaaaa1")
            print(pinCode)
            print(qrCode)
            if (pinCode != nil) {
                print("aaaaa2")
                let jsonData = try JSONEncoder().encode(InivteCodeJSON(pin_code: pinCode, qr_code: nil))
                request.httpBody = jsonData
            } else if (qrCode != nil) {
                print("ehhehe0")
                let jsonData = try JSONEncoder().encode(InivteCodeJSON(pin_code: nil, qr_code: qrCode))
                print("ehhehe1")
                request.httpBody = jsonData
            }
            
            if (pinCode != nil || qrCode != nil) {
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    defer { sem.signal() }
                    
                    if let error = error {
                        // Handle HTTP request error
                    } else if let data = data {
                        // Handle HTTP request response
                        let jsonDecoder = JSONDecoder()
                        do {
                        let parsedJSON = try jsonDecoder.decode(QueueFullJSON.self, from: data)
                            idToToReturn = parsedJSON.id
                        }
                        catch {
                            print(error)
                       }
                    } else {
                        // Handle unexpected error
                    }
                }
                task.resume()
            }                
        } catch {
        }
        
        sem.wait()
        
        return idToToReturn
    }
    
    static func deleteQueue(queue_id: Int) {
        let url = URL(string: "\(baseURL)\(pathURL)/\(queue_id)")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        do {
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
    
    static func freezeQueue(queue_id: Int) {
        let url = URL(string: "\(baseURL)\(pathURL)/freeze/\(queue_id)")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
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
    
    static func unfreezeQueue(queue_id: Int) {
        let url = URL(string: "\(baseURL)\(pathURL)/unfreeze/\(queue_id)")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
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
}

class ToDoTasksRequest {
    static let pathURL = "/tasks"
    
    
    static func loadTasks() -> [Task]? {
        
        var loadedTasks = [Task]()
        
        let sem = DispatchSemaphore.init(value: 0)
                
        let url = URL(string: "\(baseURL)\(pathURL)")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            defer { sem.signal() }
            
            if let _error = error {
                // Handle HTTP request error
            } else if let data = data {
                // Handle HTTP request response

                let jsonDecoder = JSONDecoder()
                do {
                let parsedJSON = try jsonDecoder.decode([ToDoTaskJSON].self, from: data)
                    for todoTask in parsedJSON {
                        let t = Task(queue_id: todoTask.queue_id, name: todoTask.name, color: todoTask.color, is_important: todoTask.is_important, track_expenses: todoTask.track_expenses)
                        loadedTasks.append(t)
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
    
        return loadedTasks
    }
    
    static func completeTask(task_id: Int, expenses: Int?) {
        let url = URL(string: "\(baseURL)\(pathURL)/done")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let jsonData = try JSONEncoder().encode(CompleteTaskJSON(task_id: task_id, expenses: expenses))
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
    
    static func skipTask(task_id: Int) {
        let url = URL(string: "\(baseURL)\(pathURL)/skip")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let jsonData = try JSONEncoder().encode(SkipTaskJSON(task_id: task_id))
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
}

class NotificationsRequest {
    static let pathURL = "/notifications"
    
    static func loadNotifications() -> ([Notification]?, [Notification]?) {
        
        var unreadNotifications = [Notification]()
        var readNotifications = [Notification]()
        
        let sem = DispatchSemaphore.init(value: 0)
                
        let url = URL(string: "\(baseURL)\(pathURL)")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            defer { sem.signal() }
            
            if let _error = error {
                // Handle HTTP request error
            } else if let data = data {
                // Handle HTTP request response

                let jsonDecoder = JSONDecoder()
                do {
                let parsedJSON = try jsonDecoder.decode(NotificationsJSON.self, from: data)
                    
                    for unreadMessage in parsedJSON.unread {
                        let m = Notification(message: unreadMessage.message, timestamp: unreadMessage.timestamp)
                        unreadNotifications.append(m)
                    }
                    for unreadMessage in parsedJSON.all {
                        let m = Notification(message: unreadMessage.message, timestamp: unreadMessage.timestamp)
                        readNotifications.append(m)
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
    
        return (unreadNotifications, readNotifications)
    }
}

class SettingsRequest {
    static let pathURL = "/settings"
    
    static func loadSettings() -> Settings? {
        
        var settings: Settings? = nil
        
        let sem = DispatchSemaphore.init(value: 0)
                
        let url = URL(string: "\(baseURL)\(pathURL)")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            defer { sem.signal() }
            
            if let _error = error {
                // Handle HTTP request error
            } else if let data = data {
                // Handle HTTP request response

                let jsonDecoder = JSONDecoder()
                do {
                let parsedJSON = try jsonDecoder.decode(SettingsJSON.self, from: data)
                    settings = Settings(name: parsedJSON.name, n1: parsedJSON.n1, n2: parsedJSON.n2, n3: parsedJSON.n3, n4: parsedJSON.n4, n5: parsedJSON.n5)
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
    
        return settings
    }
    
    static func saveSettings(settings: Settings) {
        let url = URL(string: "\(baseURL)\(pathURL)")!
        var request = URLRequest(url: url)
        request.setValue(
            "11111",
            forHTTPHeaderField: "user-token"
        )
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        do {
            let jsonData = try JSONEncoder().encode(SettingsJSON(name: settings.name, n1: settings.n1, n2: settings.n2, n3: settings.n3, n4: settings.n4, n5: settings.n5))
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
}
