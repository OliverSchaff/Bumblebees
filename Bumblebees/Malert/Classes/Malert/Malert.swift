//Copyright (c) 2016 Vitor Mesquita <vitor.mesquita09@jera.com.br>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

//
//  MalertManager.swift
//  Pods
//
//  Created by Vitor Mesquita on 01/11/16.
//
//

import UIKit

public class Malert: BaseMalertViewController {
    
    // MARK: - private
    private let malertPresentationManager = MalertPresentationManager()
    
    // MARK: - internal
    let malertView: MalertView
    var malertConstraints: [NSLayoutConstraint] = []
    var visibleViewConstraints: [NSLayoutConstraint] = []
    
    let tapToDismiss: Bool
    let dismissOnActionTapped: Bool
    
    lazy var visibleView: UIView = {
        let visibleView = UIView()
        visibleView.translatesAutoresizingMaskIntoConstraints = false
        return visibleView
    }()
    
    public init(title: String? = nil, customView: UIView? = nil, tapToDismiss: Bool = true, dismissOnActionTapped: Bool = true) {
        self.malertView = MalertView()
        self.tapToDismiss = tapToDismiss
        self.dismissOnActionTapped = dismissOnActionTapped
        super.init(nibName: nil, bundle: nil)
        
        self.malertView.seTitle(title)
        self.malertView.setCustomView(customView)
        
        self.animationType = .modalBottom
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = malertPresentationManager
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
    }
    
    override public func loadView() {
        super.loadView()
        
        malertView.alpha = 1
        malertView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(visibleView)
        visibleView.addSubview(malertView)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
        listenKeyboard()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeContraints()
    }
    
    override func keyboardWillShow(sender: NSNotification) {
        super.keyboardWillShow(sender: sender)
        self.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    override func keyboardWillHide(sender: NSNotification) {
        super.keyboardWillHide(sender: sender)
        self.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    deinit {
        print("dealloc ---> Malert")
    }
}

extension Malert {
    
    /* Animation config */
    public var animationType: MalertAnimationType  {
        get { return malertPresentationManager.animationType }
        set { malertPresentationManager.animationType = newValue }
    }
    
    public var presentDuration: TimeInterval {
        get { return malertPresentationManager.presentDuration }
        set { malertPresentationManager.presentDuration = newValue }
    }
    
    public var dismissDuration: TimeInterval {
        get { return malertPresentationManager.dismissDuration }
        set { malertPresentationManager.dismissDuration = newValue }
    }
    
    /* Container config */
    public var margin: CGFloat {
        get { return malertView.margin }
        set { malertView.margin = newValue }
    }
    
    public var cornerRadius: CGFloat {
        get { return malertView.cornerRadius }
        set { malertView.cornerRadius = newValue }
    }
    
    public var backgroundColor: UIColor? {
        get { return malertView.backgroundColor }
        set { malertView.backgroundColor = newValue }
    }
    
    /* Title config */
    public var textColor: UIColor {
        get { return malertView.textColor }
        set { malertView.textColor = newValue }
    }
    
    public var textAlign: NSTextAlignment {
        get { return malertView.textAlign }
        set { malertView.textAlign = newValue }
    }
    
    public var titleFont: UIFont {
        get { return malertView.titleFont }
        set { malertView.titleFont = newValue }
    }
    
    /* Buttons config */
    public var buttonsHeight: CGFloat {
        get { return malertView.buttonsHeight }
        set { malertView.buttonsHeight = newValue }
    }
    
    public var separetorColor: UIColor {
        get { return malertView.separetorColor }
        set { malertView.separetorColor = newValue }
    }
    
    public var buttonsSpace: CGFloat {
        get { return malertView.buttonsSpace }
        set { malertView.buttonsSpace = newValue }
    }
    
    public var buttonsSideMargin: CGFloat {
        get { return malertView.buttonsSideMargin }
        set { malertView.buttonsSideMargin = newValue }
    }

    public var buttonsBottomMargin: CGFloat {
        get { return malertView.buttonsBottomMargin }
        set { malertView.buttonsBottomMargin = newValue }
    }
    
    public var buttonsAxis: UILayoutConstraintAxis {
        get { return malertView.buttonsAxis }
        set { malertView.buttonsAxis = newValue }
    }
    
    public func addAction(_ malertButton: MalertAction) {
        malertView.addButton(malertButton, actionCallback: self)
    }
}
