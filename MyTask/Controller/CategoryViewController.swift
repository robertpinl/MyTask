//
//  CategoryViewController.swift
//  MyTask
//
//  Created by Robert Pinl on 06.03.2021.
//

import UIKit
import CoreData

class CategoryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadItems()
        collectionView.reloadData()
        setupLongGestureRecognizerOnCollection()
    }
    
    //MARK: - CollectionView data source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.categoryCell, for: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.item]
        cell.categoryLabel.text = category.title
        cell.categoryImage.image = UIImage(systemName: category.image!)
        
        if category.tasks?.count == 0 {
            cell.categoryItemsLabel.text = "No Item"
        } else if category.tasks?.count == 1 {
            cell.categoryItemsLabel.text = "\(category.tasks?.count ?? 0) Item"
        } else {
            cell.categoryItemsLabel.text = "\(category.tasks?.count ?? 0) Items"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = view.bounds.width / 2
        return CGSize(width: dimension, height: dimension * 0.7)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segue.tasks, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.Segue.tasks {
            let destination = segue.destination as! TasksViewController
            
            if let indexPath = self.collectionView.indexPathsForSelectedItems?.first {
                destination.selectedCategory = categories[indexPath.item]
            }
        }
        if segue.identifier == K.Segue.newCategory {
            
        }
    }
    
    //MARK: - Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: K.Segue.newCategory, sender: self)
        
    }
    
    //MARK: - Data manipulation
    func saveItems() {
        do {
            try self.context.save()
        } catch {
            print("Error saving data to context: \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
}

//MARK: - Delete Category with long press gesture
extension CategoryViewController: UIGestureRecognizerDelegate {
    
    func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView?.addGestureRecognizer(longPressedGesture)
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }

        let p = gestureRecognizer.location(in: collectionView)

        if let indexPath = collectionView?.indexPathForItem(at: p) {
            
            let alert = UIAlertController(title: "Delete Category?", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                
                self.context.delete(self.categories[indexPath.row])
                self.categories.remove(at: indexPath.row)
                self.collectionView.reloadData()
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(action)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        }
    }
}
