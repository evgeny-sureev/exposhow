//
//  ImageMapControl.swift
//  exposhow
//
//  Created by Ulitka on 12.09.15.
//  Copyright (c) 2015 Ampullarius. All rights reserved.
//

import UIKit

class ImageMap: UIView {
    
    let map: UIImageView
    let height: CGFloat
    let light: UIView
    
    init(imageName:String) {
        let image = UIImage(named: imageName)!
        height = image.size.height
        map = UIImageView(image: image)
        map.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:image.size)
        map.userInteractionEnabled = false
        light = UIView(frame: CGRectZero)
        light.backgroundColor = UIColor.redColor()
        light.userInteractionEnabled = false

        super.init(frame: CGRectZero)
        
        frame = map.frame
        addSubview(map)
        addSubview(light)
    }
    
    func hightlight(let area: CGRect) {
        light.frame = area
        light.alpha = 0.4
        
        UIView.animateWithDuration(1) {
            self.light.alpha = 0.0
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
