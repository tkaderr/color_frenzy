//
//  ColorView.swift
//  colorpicker
//
//  Created by Colin Jao on 5/12/17.
//  Copyright © 2017 Colin Jao. All rights reserved.
//

import UIKit

@IBDesignable class ColorView: UIView {

    @IBInspectable var timer: Double = 5.0 {
        didSet {
            if timer > 0 {
                //the view needs to be refreshed
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var maxArcLength: Double = 0.0
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var timerColor: UIColor = UIColor.orange
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        // 1
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        // 2
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        // 3
        let arcWidth: CGFloat = 76
        
        // 4
        let startAngle: CGFloat = 3 * 3.1415 / 4
        let endAngle: CGFloat = 3.1415 / 4
        
        // 5
        let path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        // 6
        path.lineWidth = arcWidth
        timerColor.setStroke()
        path.stroke()
        
        
        //Draw the outline
        
        //1 - first calculate the difference between the two angles
        //ensuring it is positive
        let angleDifference: CGFloat = 2 * 3.1415 - startAngle + endAngle
        
        //then calculate the arc for each single glass
        let arcLengthPerSecond = angleDifference / CGFloat(maxArcLength)
        
        //then multiply out by the actual glasses drunk
        let outlineEndAngle = arcLengthPerSecond * CGFloat(timer) + startAngle
        
        //2 - draw the outer arc
        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: bounds.width/2 - 2.5,
                                       startAngle: startAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
        
        //3 - draw the inner arc
        outlinePath.addArc(withCenter: center,
                                     radius: bounds.width/2 - arcWidth + 2.5,
                                     startAngle: outlineEndAngle,
                                     endAngle: startAngle,
                                     clockwise: false)
        
        //4 - close the path
        outlinePath.close()
        
        outlineColor.setStroke()
        if timer > 0 {
            outlinePath.lineWidth = 5.0
        } else {
            outlinePath.lineWidth = 0.0
        }
        outlinePath.stroke()
    }

}
