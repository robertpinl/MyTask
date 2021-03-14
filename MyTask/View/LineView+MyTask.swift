//
//  LineView.swift
//  MyTask
//
//  Created by Robert Pinl on 11.03.2021.
//

import UIKit

class LineView: UIView {
    
    override func awakeFromNib() {
        layer.cornerRadius = bounds.height / 2
        layer.backgroundColor = UIColor(named: "lineColor")!.cgColor
    }

}
