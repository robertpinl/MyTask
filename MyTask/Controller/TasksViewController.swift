//
//  TasksViewController.swift
//  MyTask
//
//  Created by Robert Pinl on 06.03.2021.
//

import UIKit
import CoreData

class TasksViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var taskArray = [Task]()
    var selectedCategory: Category? {
        didSet {
            loadTasks()
        }
    }
    let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()
        
    override func viewDidLoad() {
        navigationItem.title = selectedCategory?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTasks()
    }
    
    // MARK: - TableView  Delegate and Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.taskCell, for: indexPath) as! TaskTableViewCell
        let task = taskArray[indexPath.row]
        cell.taskTitleLabel.text = task.title
        cell.taskDoneImage.image = taskArray[indexPath.row].done ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        cell.taskDateLabel.text = formatter.string(from: task.date!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segue.taskDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.Segue.taskDetail {
            let destination = segue.destination as! TaskDetailViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.selectedTask = taskArray[indexPath.row]
            }
        }
        
        if segue.identifier == K.Segue.newTask {
            let destination = segue.destination as! AddNewTaskViewController
            destination.selectedCategory = selectedCategory
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    //MARK: - Add New Task
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: K.Segue.newTask, sender: self)
    }
    
    //MARK: - Data manipulation
    func saveTasks() {
        do {
            try self.context.save()
        } catch {
            print("Error saving data to context: \(error)")
        }
    }
    
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest()) {
        
        let predicate = NSPredicate(format: "parentCategory.title MATCHES %@", selectedCategory!.title!)
        
        request.predicate = predicate
        
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
 
        do {
            taskArray = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
}
