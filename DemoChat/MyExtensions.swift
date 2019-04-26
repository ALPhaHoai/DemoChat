//
//  MyExtensions.swift
//  DemoChat
//
//  Created by bruce on 2019/4/19.
//  Copyright © 2019 bruce. All rights reserved.
//

import SwifterSwift
import UIKit

extension UIImageView {
    func download(url: String, placeholder: UIImage){
        if let u = URL(string: url) {
            self.download(from: u, placeholder: placeholder)
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

extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }

    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }

    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }

        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        var insetsWidth: CGFloat = 0.0

        if let insets = padding {
            insetsWidth += insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
            textWidth -= insetsWidth
        }

        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: self.font], context: nil)

        contentSize.height = ceil(newSize.size.height) + insetsHeight
        contentSize.width = ceil(newSize.size.width) + insetsWidth

        return contentSize
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
}


public class ScaleAspectFitImageView : UIImageView {
  /// constraint to maintain same aspect ratio as the image
  private var aspectRatioConstraint:NSLayoutConstraint? = nil

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)
    self.setup()
  }

  public override init(frame:CGRect) {
    super.init(frame:frame)
    self.setup()
  }

  public override init(image: UIImage!) {
    super.init(image:image)
    self.setup()
  }

  public override init(image: UIImage!, highlightedImage: UIImage?) {
    super.init(image:image,highlightedImage:highlightedImage)
    self.setup()
  }

  override public var image: UIImage? {
    didSet {
      self.updateAspectRatioConstraint()
    }
  }

  private func setup() {
    self.contentMode = .scaleAspectFit
    self.updateAspectRatioConstraint()
  }

  /// Removes any pre-existing aspect ratio constraint, and adds a new one based on the current image
  private func updateAspectRatioConstraint() {
    // remove any existing aspect ratio constraint
    if let c = self.aspectRatioConstraint {
      self.removeConstraint(c)
    }
    self.aspectRatioConstraint = nil

    if let imageSize = image?.size, imageSize.height != 0
    {
      let aspectRatio = imageSize.width / imageSize.height
      let c = NSLayoutConstraint(item: self, attribute: .width,
                                 relatedBy: .equal,
                                 toItem: self, attribute: .height,
                                 multiplier: aspectRatio, constant: 0)
      // a priority above fitting size level and below low
        c.priority = UILayoutPriority(rawValue: (UILayoutPriority.defaultLow.rawValue + UILayoutPriority.fittingSizeLevel.rawValue) / 2)
      self.addConstraint(c)
      self.aspectRatioConstraint = c
    }
  }
}


class ScaledHeightImageView: UIImageView {

    override var intrinsicContentSize: CGSize {

        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width

            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        return CGSize(width: -1.0, height: -1.0)
    }
}
