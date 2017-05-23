//
//  ClockView.swift
//  Clock
//
//  Created by Tan Vu on 5/22/17.
//  Copyright © 2017 Tan Vu. All rights reserved.
//

import Foundation
import UIKit

class ClockView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let ctx = UIGraphicsGetCurrentContext()
        
        let rad = rect.width/3.5
        let endAngle = CGFloat(2*Double.pi)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let path = UIBezierPath()
        path.addArc(withCenter: center, radius: rad, startAngle: 0, endAngle: endAngle, clockwise: true)
        ctx?.setFillColor(UIColor.gray.cgColor)
        path.fill()
        
        ctx?.setStrokeColor(UIColor.white.cgColor)
        ctx?.setLineWidth(4.0)
        ctx?.drawPath(using: .stroke)
        
        
        for i in 1...60 {
            // save the original position and origin
            ctx?.saveGState()
            // make translation
            ctx?.translateBy(x: rect.midX, y: rect.midY)
            // make rotation
            ctx?.rotate(by: degree2radian(CGFloat(i)*6))
            
            if i % 5 == 0 {
                // if an hour position we want a line slightly longer
                drawSecondMarker(ctx!, x: rad - 15, y: 0, radius: rad, color: .white)
            } else {
                drawSecondMarker(ctx!, x: rad - 10, y: 0, radius: rad, color: .white)
            }
            ctx?.restoreGState()
        }
        
        drawText(rect: rect, ctx: ctx!, x: rect.midX, y: rect.midY, radius: rad, sides: 12, color: .red)
    }
    
    func degree2radian(_ a: CGFloat) -> CGFloat {
        let b = CGFloat(Double.pi) * a/180
        return b
    }
    
    func drawSecondMarker(_ ctx: CGContext, x: CGFloat, y: CGFloat, radius: CGFloat, color: UIColor) {
        // generate a path
        let path = CGMutablePath()
        // move to starting point on edge of circle
        path.move(to: CGPoint(x: radius, y: 0))
        // draw line of required length
        path.addLine(to: CGPoint(x: x, y: y))
        // close subpath
        path.closeSubpath()
        // add path to the context
        ctx.addPath(path)
        // set the line width
        ctx.setLineWidth(1.5)
        // set line color
        ctx.setStrokeColor(color.cgColor)
        // draw line
        ctx.strokePath()
    }
    
    func circleCircumferencePoints(_ sides:Int, x:CGFloat, y:CGFloat, radius:CGFloat, adjustment: CGFloat = 0) -> [CGPoint] {
        let angle = degree2radian(360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i = i - 1;
        }
        return points
    }
    
    func drawText(rect: CGRect, ctx: CGContext, x: CGFloat, y: CGFloat, radius: CGFloat, sides:Int, color: UIColor) {
        // Flip text co-ordinate space, see: http://blog.spacemanlabs.com/2011/08/quick-tip-drawing-core-text-right-side-up/
        ctx.translateBy(x: 0, y: rect.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        // dictates on how inset the ring of numbers will be
        let inset: CGFloat = radius/3.5
        // An adjustment of 270 degrees to position numbers correctly
        let points = circleCircumferencePoints(sides, x: x, y: y, radius: radius-inset, adjustment:270)
        for (index, p) in points.enumerated() {
            if index > 0 {
                let aFont = UIFont(name: "Optima-Bold", size: radius/5)
                // create a dictionary of attributes to be applied to the string
                let attr: CFDictionary = NSDictionary(dictionary: [NSFontAttributeName:aFont!,NSForegroundColorAttributeName: color])
                // create the attributed string
                let text = CFAttributedStringCreate(nil, "\(index)" as CFString, attr)
                // create the line of text
                let line = CTLineCreateWithAttributedString(text!)
                // retrieve the bounds of the text
                let bounds = CTLineGetBoundsWithOptions(line, .useOpticalBounds)
                // set the line width to stroke the text with
                ctx.setLineWidth(1.5)
                // set the drawing mode to stroke
                ctx.setTextDrawingMode(.stroke)
                // Set text position and draw the line into the graphics context, text length and height is adjusted for
                let xn = p.x - bounds.width/2
                let yn = p.y - bounds.midY
                ctx.textPosition = CGPoint(x: xn, y: yn)
                // the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
                CTLineDraw(line, ctx)
            }
        }
    }
}

