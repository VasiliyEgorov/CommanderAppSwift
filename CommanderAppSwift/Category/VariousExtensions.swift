//
//  VariousExtensions.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 15.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

extension Array {
    
    func filterDuplicates(includeElement:@escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element] {
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}

extension Dictionary where Key == String {
    func toAttributedStringKeys() -> [NSAttributedStringKey: Value] {
        return Dictionary<NSAttributedStringKey, Value>(uniqueKeysWithValues: map {
            key, value in (NSAttributedStringKey(key), value)
        })
    }
}
extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
extension UIViewController {
    func networkActivityStart() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func networkActivityStop() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension UITableViewCell {
    func networkActivityStart() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func networkActivityStop() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension UIActivityIndicatorView {
    func start() {
        self.isHidden = false
        self.startAnimating()
    }
    func stop() {
        self.isHidden = true
        self.stopAnimating()
    }
}
extension UIButton {
    func getSuperviewImage() -> UIImage? {
        if let imageView = self.superview as? UIImageView {
            return imageView.image
        } else {
            return nil
        }
    }
}
