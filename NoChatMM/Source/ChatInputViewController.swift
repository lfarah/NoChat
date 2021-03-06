//
//  ChatInputViewController.swift
//  NoChatTG
//
//  Created by little2s on 16/5/17.
//  Copyright © 2016年 little2s. All rights reserved.
//

import UIKit
import NoChat

public class ChatInputViewController: UIViewController, ChatInputControllerProtocol {
    
    public struct Constant {
        static let animationDuration: NSTimeInterval = 0.25
    }
    
    public var sendButtonTitle: String?
    public var textPlaceholder: String?
    
    public var inputBar: UIView!
    public var backgroundView: UIToolbar!
    public var growTextView: GrowTextView!
    public var micButton: UIButton!
    public var faceButton: UIButton!
    public var attachButton: UIButton!
    
    public var growTextViewHeightConstraint: NSLayoutConstraint!
    public var growTextViewTopConstraint: NSLayoutConstraint!
    public var growTextViewBottomConstraint: NSLayoutConstraint!
    public var growTextViewLeadingConstraint: NSLayoutConstraint!
    public var growTextViewTrailingConstraint: NSLayoutConstraint!
    
    public var textViewHeight: CGFloat = GrowTextView.Constant.minHeight
    public var inputViewHeight: CGFloat = 50
    public var inputBarHeight: CGFloat {
        return textViewHeight + growTextViewTopConstraint.constant + growTextViewBottomConstraint.constant
    }
    
    public var onHeightChange: (HeightChange -> Void)?
    public var onSendText: (String -> Void)?
    public var onChooseAttach: (() -> Void)?
    
    public override func loadView() {
        view = UIView()
        addInputBar()
        addInputViews()
        addConstraints()
    }
    
    private let keyboardMan = KeyboardMan()
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardAnimation()
        
        growTextView.growTextViewDelegate = self
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardMan.keyboardObserveEnabled = true
    }
    
    public override func viewWillDisappear(animated: Bool) {
        keyboardMan.keyboardObserveEnabled = false
        super.viewWillDisappear(animated)
    }
    
    public func clearInputText() {
        growTextView.clear()
    }
    
    public func endInputting(animated: Bool) {
        view.endEditing(animated)
    }
    
    @objc
    public func didTapAttachButton(sender: UIButton) {
        onChooseAttach?()
    }
    
    private func addInputBar() {
        inputBar = UIView()
        view.addSubview(inputBar)
        
        backgroundView = UIToolbar()
        inputBar.addSubview(backgroundView)
    }
    
    private func addInputViews() {
        let textFont = UIFont.systemFontOfSize(16)
        
        growTextView = GrowTextView()
        growTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        growTextView.layer.borderWidth = 0.5
        growTextView.layer.cornerRadius = 5
        growTextView.layer.masksToBounds = true
        growTextView.font = textFont
        growTextView.returnKeyType = .Send
        growTextView.enablesReturnKeyAutomatically = true
        inputBar.addSubview(growTextView)
        
        micButton = UIButton(type: .System)
        micButton.setImage(imageFactory.createImage("Voice"), forState: .Normal)
        micButton.setImage(imageFactory.createImage("VoiceHL"), forState: .Highlighted)
        inputBar.addSubview(micButton)
        
        faceButton = UIButton(type: .System)
        faceButton.setImage(imageFactory.createImage("Emotion"), forState: .Normal)
        faceButton.setImage(imageFactory.createImage("EmotionHL"), forState: .Highlighted)
        inputBar.addSubview(faceButton)
        
        attachButton = UIButton(type: .System)
        attachButton.setImage(imageFactory.createImage("Attach"), forState: .Normal)
        attachButton.setImage(imageFactory.createImage("AttachHL"), forState: .Highlighted)
        attachButton.addTarget(self, action: #selector(didTapAttachButton), forControlEvents: .TouchUpInside)
        inputBar.addSubview(attachButton)
    }
    
    private func addConstraints() {
        inputBar.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        growTextView.translatesAutoresizingMaskIntoConstraints = false
        micButton.translatesAutoresizingMaskIntoConstraints = false
        faceButton.translatesAutoresizingMaskIntoConstraints = false
        attachButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: inputBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: inputBar, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: inputBar, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        
        
        backgroundView.setContentHuggingPriority(UILayoutPriority(240), forAxis: .Vertical)
        backgroundView.setContentCompressionResistancePriority(UILayoutPriority(240), forAxis: .Vertical)
        
        inputBar.addConstraint(NSLayoutConstraint(item: inputBar, attribute: .Top, relatedBy: .Equal, toItem: backgroundView, attribute: .Top, multiplier: 1, constant: 0))
        inputBar.addConstraint(NSLayoutConstraint(item: inputBar, attribute: .Leading, relatedBy: .Equal, toItem: backgroundView, attribute: .Leading, multiplier: 1, constant: 0))
        inputBar.addConstraint(NSLayoutConstraint(item: inputBar, attribute: .Trailing, relatedBy: .Equal, toItem: backgroundView, attribute: .Trailing, multiplier: 1, constant: 0))
        inputBar.addConstraint(NSLayoutConstraint(item: inputBar, attribute: .Bottom, relatedBy: .Equal, toItem: backgroundView, attribute: .Bottom, multiplier: 1, constant: 0))
        
        
        growTextViewHeightConstraint = NSLayoutConstraint(item: growTextView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 35)
        
        growTextViewTopConstraint = NSLayoutConstraint(item: growTextView, attribute: .Top, relatedBy: .Equal, toItem: inputBar, attribute: .Top, multiplier: 1, constant: 7.5)
        growTextViewBottomConstraint = NSLayoutConstraint(item: inputBar, attribute: .Bottom, relatedBy: .Equal, toItem: growTextView, attribute: .Bottom, multiplier: 1, constant: 7.5)
        growTextViewLeadingConstraint = NSLayoutConstraint(item: growTextView, attribute: .Leading, relatedBy: .Equal, toItem: inputBar, attribute: .Leading, multiplier: 1, constant: 40)
        growTextViewTrailingConstraint = NSLayoutConstraint(item: inputBar, attribute: .Trailing, relatedBy: .Equal, toItem: growTextView, attribute: .Trailing, multiplier: 1, constant: 80)
        
        inputBar.addConstraints([growTextViewHeightConstraint, growTextViewTopConstraint, growTextViewBottomConstraint, growTextViewLeadingConstraint, growTextViewTrailingConstraint])
        
        
        
        inputBar.addConstraint(NSLayoutConstraint(item: micButton, attribute: .Leading, relatedBy: .Equal, toItem: inputBar, attribute: .Leading, multiplier: 1, constant: 0))
        inputBar.addConstraint(NSLayoutConstraint(item: micButton, attribute: .Bottom, relatedBy: .Equal, toItem: inputBar, attribute: .Bottom, multiplier: 1, constant: 0))
        inputBar.addConstraint(NSLayoutConstraint(item: micButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40))
        inputBar.addConstraint(NSLayoutConstraint(item: micButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50))
        
        inputBar.addConstraint(NSLayoutConstraint(item: faceButton, attribute: .Trailing, relatedBy: .Equal, toItem: attachButton, attribute: .Leading, multiplier: 1, constant: 4))
        inputBar.addConstraint(NSLayoutConstraint(item: faceButton, attribute: .Bottom, relatedBy: .Equal, toItem: inputBar, attribute: .Bottom, multiplier: 1, constant: 0))
        inputBar.addConstraint(NSLayoutConstraint(item: faceButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40))
        inputBar.addConstraint(NSLayoutConstraint(item: faceButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50))
        
        inputBar.addConstraint(NSLayoutConstraint(item: attachButton, attribute: .Trailing, relatedBy: .Equal, toItem: inputBar, attribute: .Trailing, multiplier: 1, constant: 0))
        inputBar.addConstraint(NSLayoutConstraint(item: attachButton, attribute: .Bottom, relatedBy: .Equal, toItem: inputBar, attribute: .Bottom, multiplier: 1, constant: 0))
        inputBar.addConstraint(NSLayoutConstraint(item: attachButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40))
        inputBar.addConstraint(NSLayoutConstraint(item: attachButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50))
        
    }
    
    private func setupKeyboardAnimation() {
        keyboardMan.postKeyboardInfo = { [unowned self] _, info in
            let oldH = self.inputViewHeight
            let newH = info.action == .Hide ? self.inputBarHeight :  self.inputBarHeight + info.height
            
            self.onHeightChange?(HeightChange(oldHeight: oldH, newHeight: newH))
            
            self.inputViewHeight = newH
        }
    }
    
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        let oldH = inputViewHeight
        let newH = inputBarHeight
        UIView.performWithoutAnimation {
            self.onHeightChange?(HeightChange(oldHeight: oldH, newHeight: newH))
        }
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

}

extension ChatInputViewController: GrowTextViewDelegate {
    public func growTextViewDidChange(textView: GrowTextView, height: CGFloat) {
        let oldH = inputViewHeight
        let newH = inputViewHeight + (height - textViewHeight)
        self.textViewHeight = height
        self.inputViewHeight = newH
        
        self.growTextViewHeightConstraint.constant = height
        view.setNeedsLayout()
        UIView.animateWithDuration(Constant.animationDuration, animations: { () -> Void in
            self.onHeightChange?(HeightChange(oldHeight: oldH, newHeight: newH))
        })
    }
    
    public func growTextViewDidBeginEditing(textView: GrowTextView) {
        
    }
    
    public func growTextViewDidSend(textView: GrowTextView, text: String) {
        onSendText?(text)
    }
}
