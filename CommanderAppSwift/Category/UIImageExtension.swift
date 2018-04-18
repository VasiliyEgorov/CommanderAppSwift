//
//  UIImageExtension.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

extension UIImage {
    
    var data : Data? {
        return UIImagePNGRepresentation(self)
    }
    
    class func resizeImage(image: UIImage?, scaledTo newSize: CGSize) -> UIImage? {
        guard let image = image else { return nil }
        if image.size.width < newSize.width && image.size.height < newSize.height {
            return image
        }
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    class func scaleImage(image: UIImage?, toFrame rect:CGRect) -> UIImage? {
        guard let image = image else { return nil }
        let newScaleForFrame : CGFloat
        let newPhotoSizeWidth = rect.size.width * 2
        let newPhotoSizeHeight = newPhotoSizeWidth * image.size.height / image.size.width
        guard let resizedImage = UIImage.resizeImage(image: image, scaledTo: CGSize(width: newPhotoSizeWidth, height: newPhotoSizeHeight)) else { return nil }

        if image.size.width < image.size.height {
            let currentPhotoWidth = resizedImage.size.width
            newScaleForFrame = currentPhotoWidth / rect.size.width
        } else {
            let currentPhotoHeight = resizedImage.size.height
            newScaleForFrame = currentPhotoHeight / rect.size.width
        }
        let scaledImage = UIImage.init(cgImage: resizedImage.cgImage!, scale: newScaleForFrame, orientation: resizedImage.imageOrientation)
        
        return scaledImage
    }
    
    class func cropImage(image: UIImage?, toRect rect: CGRect) -> UIImage? {
        guard let image = image else { return nil }
        let rad = {(_ deg: CGFloat) -> CGFloat in
            return deg / 180.0 * CGFloat.pi
        }
        
        var rectTransform : CGAffineTransform
        
        switch image.imageOrientation {
        case .left, .leftMirrored: rectTransform = CGAffineTransform(rotationAngle: rad(90)).translatedBy(x: 0, y: -image.size.height)
        case .right, .rightMirrored: rectTransform = CGAffineTransform(rotationAngle: rad(-90)).translatedBy(x: -image.size.width, y: 0)
        case .down, .downMirrored: rectTransform = CGAffineTransform(rotationAngle: rad(-180)).translatedBy(x: -image.size.width, y: -image.size.height)
        default: rectTransform = CGAffineTransform.identity
        }
        
        rectTransform = rectTransform.scaledBy(x: image.scale, y: image.scale)
        
        let cropFromY : CGFloat
        let cropFromX : CGFloat
        let rectToCrop : CGRect
        
        if image.size.width < image.size.height {
            cropFromY = (image.size.height - rect.size.height) / 2
            cropFromX = 0
            rectToCrop = CGRect(x: cropFromX, y: cropFromY, width: rect.size.width, height: rect.size.height)
        } else {
            cropFromX = (image.size.width - rect.size.width) / 2
            cropFromY = 0
            rectToCrop = CGRect(x: cropFromX, y: cropFromY, width: rect.size.width, height: rect.size.height)
        }
        
        let transformedCropSquare = rectToCrop.applying(rectTransform)
        
        let imageRef = image.cgImage!.cropping(to: transformedCropSquare)
        let croppedImage = UIImage.init(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
        
        return croppedImage
    }
    
    class func cropImage(image: UIImage?, byCropViewFrame rect:CGRect) -> UIImage? {
        guard let image = image else { return nil }
        let rad = {(_ deg: CGFloat) -> CGFloat in
            return deg / 180.0 * CGFloat.pi
        }
        
        var rectTransform : CGAffineTransform
        
        switch image.imageOrientation {
        case .left: rectTransform = CGAffineTransform(rotationAngle: rad(90)).translatedBy(x: 0, y: -image.size.height)
        case .right: rectTransform = CGAffineTransform(rotationAngle: rad(-90)).translatedBy(x: -image.size.width, y: 0)
        case .down: rectTransform = CGAffineTransform(rotationAngle: rad(-180)).translatedBy(x: -image.size.width, y: -image.size.height)
        default: rectTransform = CGAffineTransform.identity
        }
        
        rectTransform = rectTransform.scaledBy(x: image.scale, y: image.scale)
        
        let cropFromY : CGFloat
        let cropFromX : CGFloat
        let rectToCrop : CGRect
        
        if image.size.width < image.size.height {
            cropFromY = rect.origin.y
            cropFromX = 0
            rectToCrop = CGRect(x: cropFromX, y: cropFromY, width: rect.size.width, height: rect.size.height)
        } else {
            cropFromX = rect.origin.x
            cropFromY = 0
            rectToCrop = CGRect(x: cropFromX, y: cropFromY, width: rect.size.width, height: rect.size.height)
        }
        
        let transformedCropSquare = rectToCrop.applying(rectTransform)
        
        let imageRef = image.cgImage!.cropping(to: transformedCropSquare)
        let croppedImage = UIImage.init(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
        
        return croppedImage
    }
    
    class func mergeLayer(andView view:UIView) -> UIImage {
        let imgSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height)
        UIGraphicsBeginImageContextWithOptions(imgSize, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }
    class func rotateCounterClockWiseByMinusHalfPi(image:UIImage) -> UIImage {
        let rad = {(_ deg: CGFloat) -> CGFloat in
            return deg / 180.0 * CGFloat.pi
        }
        let rotatedViewBox = UIView.init(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let t = CGAffineTransform.init(rotationAngle: rad(90))
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        bitmap?.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        bitmap?.rotate(by: rad(-90))
        bitmap?.scaleBy(x: 1.0, y: -1.0)
        bitmap?.draw(image.cgImage!, in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width, height: image.size.height))
        
        let rotated = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotated!
    }
    class func lanczosScaleFilter(image: UIImage?, scaleTo scale: CGFloat) -> UIImage? {
        guard let image = image else { return nil }
        let context = CIContext.init(options: [kCIContextUseSoftwareRenderer: false])
        let inputImage = UIImage.init(cgImage: image.cgImage!)
        let lanczos = CIFilter.init(name: "CILanczosScaleTransform")
        
        lanczos?.setValue(inputImage, forKey: kCIInputImageKey)
        lanczos?.setValue(scale, forKey: kCIInputScaleKey)
        guard let output = lanczos?.outputImage else { return nil }
        
        let cgImage = context.createCGImage(output, from: output.extent)
        
        let filteredImage = UIImage.init(cgImage: cgImage!)
        
        return filteredImage
    }
}
