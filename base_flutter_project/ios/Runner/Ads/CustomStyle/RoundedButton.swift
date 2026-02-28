//
//  RoundedButton.swift
//  Runner
//
//  Created by mom hang on 04/03/2024.
//

import Foundation
@IBDesignable
class RoundedButton : UIButton{
    override func layoutSubviews() {
        layer.cornerRadius = 10
    }
}
