//
//  UIImageExtension.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

extension UIImage {
    
    var png : Data? {
        return UIImagePNGRepresentation(self)
    }
}
