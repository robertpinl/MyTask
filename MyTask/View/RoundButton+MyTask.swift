//
//  RoundButton.swift
//  MyTask
//
//  Created by Robert Pinl on 09.03.2021.
//

import UIKit

class RoundButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {setTitle("Not Yet?", for: .selected)
                backgroundColor = .lightGray
                setTitleColor(.darkGray, for: .selected)
            } else {
                setTitle("Done", for: .normal)
                backgroundColor = UIColor(named: "greenButtonBackground")
                setTitleColor(UIColor(named: "greenButtonFont"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        layer.cornerRadius = 10
    }
}
