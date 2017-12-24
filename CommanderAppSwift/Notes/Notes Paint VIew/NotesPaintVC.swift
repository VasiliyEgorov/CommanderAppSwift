//
//  NotesPaintVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
protocol NotesPaintDelegate : class {
    func receivePaintImage(image: UIImage?)
}
class NotesPaintVC: UIViewController {
    @IBOutlet weak var doodleView: DoodleView!
    @IBOutlet weak var colorPalette: ColorPalette!
    weak var delegate : NotesPaintDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doodleView.delegate = self.colorPalette 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = cancelButton
        let useButton = UIBarButtonItem.init(title: "Use", style: .plain, target: self, action: #selector(useButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = useButton
    }
    // MARK: - Crop view
    private func cropDoodleViewAndMakeImage() -> UIImage? {
        var arrayWithOriginsY = Array<CGFloat>()
        var arrayWithRects = Array<CGRect>()
        
        for path in doodleView.pathsArray {
            let frame = self.doodleView.convert(path.bounds, to: self.doodleView)
            arrayWithOriginsY.append(frame.origin.y)
            arrayWithRects.append(frame)
        }
        let originsSorted = arrayWithOriginsY.sorted()
        let heightsSorted = arrayWithRects.sorted { (objOne, objTwo) -> Bool in
            return objOne.size.height + objOne.origin.y < objTwo.size.height + objTwo.origin.y
        }
        guard let originMinY = originsSorted.first else { return nil }
        guard let originMaxY = originsSorted.last else { return nil }
        guard let maxRect = heightsSorted.last else { return nil }
        
        var halfMaxLineWidth : CGFloat = 0
        var halfMinLineWidth : CGFloat = 0
        
        for path in doodleView.pathsArray {
            let frame = doodleView.convert(path.bounds, to: self.doodleView)
            if frame.origin.y == originMaxY {
                halfMaxLineWidth = path.lineWidth / 2
            }
            if frame.origin.y == originMinY {
                halfMinLineWidth = path.lineWidth / 2
            }
        }
        let frameToCrop = CGRect(x: 0, y: originMinY - halfMinLineWidth, width: self.doodleView.frame.size.width, height: maxRect.origin.y + maxRect.size.height - originMinY + halfMaxLineWidth + halfMinLineWidth)
        
        let merdged = UIImage.mergeLayer(andView: self.doodleView)
        let cropped = UIImage.cropImage(image: merdged, byCropViewFrame: frameToCrop)
        
        return cropped
    }
    // MARK: - Navigation Buttons Action
    @objc private func cancelButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func useButtonAction(_ sender: UIBarButtonItem) {
        let image = cropDoodleViewAndMakeImage()
            self.delegate?.receivePaintImage(image: image)
            self.navigationController?.popViewController(animated: true)
    }
}
