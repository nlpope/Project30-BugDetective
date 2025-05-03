//  File: String+Ext.swift
//  Project: Project30-BugDetective
//  Created by: Noah Pope on 5/2/25.

import UIKit
import CoreGraphics

extension String
{
    func convertToImage(atSize size: CGSize) -> UIImage?
    {
        guard let sourceFile  = Bundle.main.path(forResource: self.replacingOccurrences(of: "Large", with: "Thumb"), ofType: nil)
        else { return nil }
                
        guard let OGImg = UIImage(contentsOfFile: sourceFile)
        else { return UIImage(systemName: "xmark")! }
        
        let renderRect  = CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height))
        let renderer    = UIGraphicsImageRenderer(size: renderRect.size)
        
        let rounded     = renderer.image { ctx in
            ctx.cgContext.addEllipse(in: renderRect)
            ctx.cgContext.clip()
            OGImg.draw(in: renderRect)
        }
        
        return rounded
    }
}
