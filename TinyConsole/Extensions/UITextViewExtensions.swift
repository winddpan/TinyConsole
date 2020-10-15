//
//  UITextViewExtensions.swift
//  TinyConsole
//
//  Created by Devran on 30.09.19.
//

import Foundation

internal extension UITextView {
    static let console: UITextView = {
        let textView = UnselectableTextView()
        textView.backgroundColor = UIColor.black
        textView.isEditable = false
        textView.alwaysBounceVertical = true
        textView.contentInset = .zero
        if #available(iOS 11.0, *) {
            textView.contentInsetAdjustmentBehavior = .never
        }
        return textView
    }()

    func clear() {
        text = ""
    }

    func boundsHeightLessThenContentSizeHeight() -> Bool {
        return frame.height < contentSize.height
    }
}
