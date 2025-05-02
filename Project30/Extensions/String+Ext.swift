//  File: String+Ext.swift
//  Project: Project30-BugDetective
//  Created by: Noah Pope on 5/2/25.

import UIKit
import CoreGraphics

extension String
{
    // NOW WE'RE USING WHATS BEEN LOADED INTO JPEG ARRAY VIA THE BUNDLE.MAIN.RESOURCEPATH
    // VS BUNDLE.MAIN.PATH(FORRESOURCE...)
    //foreach img run this then stash in array
    //run instr before testing resize logic
    func resize(for size: CGSize) -> UIImage?
    {
        guard let originalImage   = UIImage(
            contentsOfFile: Bundle.main.path(forResource: self.replacingOccurrences(of: "Large", with: "Thumb"), ofType: nil)!
        )
        else { return UIImage(systemName: "xmark")}
        
        //NOW SET UP RENDERRECT
        let renderRect      = CGRect(origin: .zero, size: CGSize(width: CellRows.width, height: CellRows.height))
        let renderer        = UIGraphicsImageRenderer(size: renderRect.size)
        
        let rounded         = renderer.image { ctx in
            #warning("why does removing .addEllipse result in clip: empty path soft error?")
            ctx.cgContext.addEllipse(in: renderRect)
            #warning("not too sure what .clip is doing, & why it only works w .addEllipse")
            /**hint: the ellipse doesn't get read as a circle until we add .clip - all I see are squares until .clip is involved**/
            ctx.cgContext.clip()
            originalImage.draw(in: renderRect)
        }
        
                        
        return renderer.image { ctx in
            orig.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
#warning("HERE, HERE IS WHERE YOU WANNA CHANGE THE SIZE OF EACH IMG")
//    guard let originalImage = UIImage(
//        contentsOfFile: Bundle.main.path(forResource: items[indexPath.row % items.count].replacingOccurrences(of: "Large", with: "Thumb"), ofType: nil)!
//    )
//    else { return cell }

    
    /**making the render rectangle the size of the tableView row height so img sizes don't conflict w said height**/
//    let renderRect      = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
//    let renderer        = UIGraphicsImageRenderer(size: renderRect.size)
//
//    let rounded         = renderer.image { ctx in
//        #warning("why does removing .addEllipse result in clip: empty path soft error?")
//        ctx.cgContext.addEllipse(in: renderRect)
//        #warning("not too sure what .clip is doing, & why it only works w .addEllipse")
//        /**hint: the ellipse doesn't get read as a circle until we add .clip - all I see are squares until .clip is involved**/
//        ctx.cgContext.clip()
//        original.draw(in: renderRect)
//    }
//
//    cell.imageView?.image               = rounded
}
