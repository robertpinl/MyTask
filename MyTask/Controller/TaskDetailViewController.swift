//
//  TaskDetailViewController.swift
//  MyTask
//
//  Created by Robert Pinl on 06.03.2021.
//

import UIKit
import CoreData

class TaskDetailViewController: UIViewController, UITextViewDelegate {
    
    var selectedTask: Task?
    var currentTask = [Task]()
    var subTaskArray = [Subtask]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadTasks()
        loadSubTask()
        
        navigationItem.title = currentTask[0].title
        textView.text = currentTask[0].text
        datePicker.date = currentTask[0].date ?? Date()
        
        if currentTask[0].done {
            doneButton.isSelected = true
        } else {
            doneButton.isSelected = false
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let updatedTask = currentTask[0]
        updatedTask.text = textView.text
        updatedTask.date = datePicker.date
        saveTask()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        let updatedTask = currentTask[0]
        updatedTask.text = textView.text
        updatedTask.date = datePicker.date
        updatedTask.done = !updatedTask.done
        
        saveTask()
        
        sender.isSelected = updatedTask.done ? true : false
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete Task?", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.context.delete(self.currentTask[0])
            self.saveTask()
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data manipulation
    func saveTask() {
        do {
            try self.context.save()
        } catch {
            print("Error saving data to context: \(error)")
        }
    }
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest()) {
        
        let predicate = NSPredicate(format: "title MATCHES %@", selectedTask!.title!)
        
        request.predicate = predicate
        
        do {
            currentTask = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    func loadSubTask(with request: NSFetchRequest<Subtask> = Subtask.fetchRequest()) {
        
        let predicate = NSPredicate(format: "parentTask.title MATCHES %@", selectedTask!.title!)
        
        request.predicate = predicate
        
        do {
            subTaskArray = try context.fetch(request)
            print(subTaskArray)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
}

//MARK: - Subtask Tableview Delegate and Datasource
extension TaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subTaskArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < subTaskArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.subTaskCell, for: indexPath)
            cell.textLabel?.text = subTaskArray[indexPath.row].title
            cell.textLabel?.textColor = subTaskArray[indexPath.row].done ? .gray : .label
            cell.imageView?.image = subTaskArray[indexPath.row].done ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.subTaskCell, for: indexPath)
            cell.imageView?.image = UIImage(systemName: "plus.circle")
            cell.textLabel?.textColor = .gray
            cell.textLabel?.text = "Add new subtask"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < subTaskArray.count {
            subTaskArray[indexPath.row].done = !subTaskArray[indexPath.row].done
            tableView.reloadData()
        } else {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "New SubTask", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add SubTask", style: .default) { (action) in
                
                if textField.hasText {
                    
                    let newSubTask = Subtask(context: self.context)
                    newSubTask.title = textField.text!
                    newSubTask.done = false
                    newSubTask.parentTask = self.currentTask[0]
                    
                    self.saveTask()
                    
                    self.subTaskArray.append(newSubTask)
                    self.resignFirstResponder()
                    tableView.reloadData()
                }
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "SubTask"
                textField = alertTextField
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(cancel)
            alert.addAction(action)
            self.resignFirstResponder()
            present(alert, animated: true, completion: nil)
        }
    }
}
