//
//  BackgroundView.swift
//  MyTask
//
//  Created by Robert Pinl on 09.03.2021.
//

import UIKit

class BackgroundView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 8
        layer.borderWidth = 0.65
        layer.borderColor = UIColor(named: "lineColor")!.cgColor
    }
}
