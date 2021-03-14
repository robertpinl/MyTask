//
//  AddNewCategoryViewController.swift
//  MyTask
//
//  Created by Robert Pinl on 11.03.2021.
//

import UIKit

class AddNewCategoryViewController: UIViewController, UITextFieldDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var imageButtons = [UIButton]()
    var index = 0
    var selectedImage: String = "person"
    let icons = ["person", "person.2", "phone", "airplane", "paperplane", "globe", "briefcase",
                 "chart.bar",  "folder", "folder.badge.person.crop", "tray.full", "doc", "list.bullet.rectangle",
                 "note.text", "calendar", "book.closed", "graduationcap", "paperclip",
                 "flame", "exclamationmark.triangle", "star", "bell", "camera", "bubble.right",
                 "envelope", "mail.stack", "cart", "wrench", "house", "lock",
                 "pin", "car", "cross", "face.smiling", "crown", "photo",  ]
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var buttonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = "Title"
        textField.textColor = .lightGray
        
        
        let height = view.bounds.width / 7
        let width = view.bounds.width / 7
        
        for row in 0..<6 {
            for column in 0..<6 {
                let imageButton = IconButton()
                
                imageButton.setImage(UIImage(systemName: icons[index]), for: .normal)
                imageButton.accessibilityIdentifier = icons[index]
                imageButton.tintColor = UIColor(named: "mainGreen")
                imageButton.layer.cornerRadius = height / 2
                imageButton.addTarget(self, action: #selector(iconSelected(_:)), for: .touchUpInside)
                index += 1
                
                let frame = CGRect(x: CGFloat(column) * width, y: CGFloat(row) * height, width: width, height: height)
                imageButton.frame = frame
                
                buttonView.addSubview(imageButton)
                imageButtons.append(imageButton)
            }
        }
        
        print(imageButtons[0].bounds.width)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.textColor = .label
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
    @objc func iconSelected(_ sender: UIButton) {
        selectedImage = sender.accessibilityIdentifier!
        
        for button in imageButtons {
            button.isSelected = false
        }
        
        sender.isSelected = true
        
        textField.endEditing(true)
    }
    
    @IBAction func backgroundPressed(_ sender: UITapGestureRecognizer) {
        resignFirstResponder()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        saveCategory()
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Data manipulation
    func saveCategory() {
        do {
            let newCategory = Category(context: context)
            newCategory.title = textField.text
            newCategory.image = selectedImage
            try self.context.save()
        } catch {
            print("Error saving data to context: \(error)")
        }
    }
}
