//
//  IconButton+MyTask.swift
//  MyTask
//
//  Created by Robert Pinl on 11.03.2021.
//

import UIKit

class IconButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.15) {
                    self.backgroundColor = UIColor(named: "mainGreen")
                    self.tintColor = .white
                }
            } else {
                UIView.animate(withDuration: 0.15) {
                    self.backgroundColor = .none
                    self.tintColor = UIColor(named: "mainGreen")
                }
            }
        }
    }
}
