//
//  AddNewTaskViewController.swift
//  MyTask
//
//  Created by Robert Pinl on 10.03.2021.
//

import UIKit

class AddNewTaskViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category?
    let tasks = TaskDetailViewController()
    var newTask = Task()
    var subTaskArray = [Subtask]()
    
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTask = Task(context: context)
        newTask.parentCategory = selectedCategory
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        newTask.date = datePicker.date
        self.saveTask()
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Data manipulation
    func saveTask() {
        do {
            try self.context.save()
        } catch {
            print("Error saving data to context: \(error)")
        }
    }
}

//MARK: - TextView Delegate
extension AddNewTaskViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        newTask.title = titleLabel.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        newTask.text = textView.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}

//MARK: - SubTask TableView Delegate and Datasource
extension AddNewTaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subTaskArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < subTaskArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.newSubTaskCell, for: indexPath)
            cell.textLabel?.text = subTaskArray[indexPath.row].title
            cell.textLabel?.textColor = .label
            cell.imageView?.image = UIImage(systemName: "minus.circle.fill")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.newSubTaskCell, for: indexPath)
            cell.imageView?.image = UIImage(systemName: "plus.circle")
            cell.textLabel?.textColor = .gray
            cell.textLabel?.text = "Add new subtask"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < subTaskArray.count {
            context.delete(subTaskArray[indexPath.row])
            subTaskArray.remove(at: indexPath.row)
            tableView.reloadData()
        } else {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "New SubTask", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add SubTask", style: .default) { (action) in
                
                if textField.hasText {
                    
                    let newSubTask = Subtask(context: self.context)
                    newSubTask.title = textField.text!
                    newSubTask.done = false
                    newSubTask.parentTask = self.newTask
                    
                    self.saveTask()
                    
                    self.subTaskArray.append(newSubTask)
                    self.titleLabel.endEditing(true)
                    self.textView.endEditing(true)
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
            present(alert, animated: true, completion: nil)
        }
    }
}

