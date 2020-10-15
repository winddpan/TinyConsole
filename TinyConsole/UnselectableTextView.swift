//
//  UnselectableTextView.swift
//  HJSwift
//
//  Created by PAN on 2018/9/19.
//  Copyright © 2018年 YR. All rights reserved.
//

import Foundation
import UIKit

open class UnselectableTextView: UITextView {
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        // Native UITextView links gesture recognizers are broken on iOS 11.0-11.1:
        // https://stackoverflow.com/questions/46143868/xcode-9-uitextview-links-no-longer-clickable
        // So we add our own UITapGestureRecognizer.
        linkGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textTapped))
        linkGestureRecognizer.numberOfTapsRequired = 1
        addGestureRecognizer(linkGestureRecognizer)
        linkGestureRecognizer.isEnabled = true
        isSelectable = false
    }

    private var linkGestureRecognizer: UITapGestureRecognizer!

    // public required to prevent blue background selection from any situation
    override public var selectedTextRange: UITextRange? {
        get { return nil }
        set {}
    }

    @objc open func textTapped(recognizer: UITapGestureRecognizer) {
        guard recognizer == linkGestureRecognizer else {
            return
        }
        var location = recognizer.location(in: self)
        location.x -= textContainerInset.left
        location.y -= textContainerInset.top
        let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        let characterRange = NSRange(location: characterIndex, length: 1)

        if let attachment = attributedText?.attribute(.attachment, at: characterIndex, effectiveRange: nil) as? NSTextAttachment {
            if #available(iOS 10.0, *) {
                _ = delegate?.textView?(self, shouldInteractWith: attachment, in: characterRange, interaction: .invokeDefaultAction)
            } else {
                _ = delegate?.textView?(self, shouldInteractWith: attachment, in: characterRange)
            }
        }
        if let url = attributedText?.attribute(.link, at: characterIndex, effectiveRange: nil) as? URL {
            if #available(iOS 10.0, *) {
                _ = delegate?.textView?(self, shouldInteractWith: url, in: characterRange, interaction: .invokeDefaultAction)
            } else {
                _ = delegate?.textView?(self, shouldInteractWith: url, in: characterRange)
            }
        }
    }
}
