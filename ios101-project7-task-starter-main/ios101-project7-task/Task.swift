//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Encodable, Decodable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    var createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    var id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {
    
    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {
        
        //Handle potential errors during encoding by using do/catch
        do {
            let encoder = PropertyListEncoder()
            let encodedTasks = try encoder.encode(tasks)
            
            // Save the encoded tasks data to UserDefaults
            UserDefaults.standard.set(encodedTasks, forKey: "savedTasks")
        } catch {
            print("Error")
        }
    }
    
    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        // Attempt to retrieve the saved tasks data from UserDefaults
        if let savedTasksData = UserDefaults.standard.data(forKey: "savedTasks") {
            // Convert the data back to an array of tasks using PropertyListDecoder
            do {
                let decoder = PropertyListDecoder()
                let decodedTasks = try decoder.decode([Task].self, from: savedTasksData)
                return decodedTasks
            } catch {
                print("Error decoding tasks: \(error.localizedDescription)")
            }
        }
        return []
    }
        // Add a new task or update an existing task with the current task.
        func save() {
            // Get the array of saved tasks
            var tasks = Task.getTasks()
            
            // Check if the current task already exists in the tasks array
            //firstIndex(where:)Returns the first index in which an element of the collection satisfies the given predicate.
            //$0 represents each element in the array
            if let existingIndex = tasks.firstIndex(where: { $0.id == self.id }) {
                
                // Update the existing task
                tasks[existingIndex] = self
                
            } else {
                // Add the new task to the end of the array
                tasks.append(self)
            }
            
            // Save the updated tasks array to UserDefaults
            Task.save(tasks)
        }
    }
