//
//  DataExtension.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

extension Data {
    var uiImage : UIImage? {
        return UIImage(data: self)
    }
    
    init?(imageName : String) {
        self.init()
        guard let img = UIImage.init(named: imageName) else { return nil }
        guard let data = UIImagePNGRepresentation(img) else { return nil }
        self = data
    }
}
