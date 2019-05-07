//
//  MyExtensions.swift
//  DemoChat
//
//  Created by bruce on 2019/4/19.
//  Copyright © 2019 bruce. All rights reserved.
//

import SwifterSwift
import UIKit
import Kingfisher

extension UIImageView {
    func download(url: String?, placeholder: UIImage){
        if let unwapUrl = url, let u = URL(string: unwapUrl) {
            self.kf.setImage(with: u, placeholder: placeholder) //Kingfisher cache image
//            self.download(from: u, placeholder: placeholder)
        } else {
            self.image = placeholder
        }
    }
}

extension UIViewController {
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        
        // duration in seconds
        let duration: Double = 5
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
}


extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}




class MyTextFieldPadding: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 100)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension UITableView {
    func deselectAllItems(animated: Bool){
        guard let selectedRows = indexPathsForSelectedRows else {
            return
        }
        for indexPath in selectedRows {
            deselectRow(at: indexPath, animated: animated)
        }
    }
    
    func updateCell(at indexPath: IndexPath){
        beginUpdates()
        reloadRows(at: [indexPath], with: .none)
        endUpdates()
    }
    
    func myScrollToBottom(){
        guard let lastRow = indexPathForLastRow, lastRow != IndexPath(row: 0, section: 0) else { return }
        scrollToRow(at:  lastRow, at: .bottom, animated: false)
    }
}

