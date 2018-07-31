//
//  ButtonView.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 01.07.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonView: UIView, Blinkable {
    
    private var action: (()->Void)?
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return titleLabel
    }()
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        shrink()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        unshrink()
        action?()
    }
    
    func setAction(_ action: @escaping ()->()) {
        self.action = action
    }
    
    func setTitle(_ title: String?) {
        self.title = title
    }
}
