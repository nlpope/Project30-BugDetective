//  File: scraps.swift
//  Project: Project30-BugDetective
//  Created by: Noah Pope on 4/22/25.

import Foundation
/**
 SHADOWED CELL RENDERING
 
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
 {
     let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

     /**find the image for this cell, and load its thumbnail**/
     let currentImage = items[indexPath.row % items.count]
     let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
     let path = Bundle.main.path(forResource: imageRootName, ofType: nil)!
     let original = UIImage(contentsOfFile: path)!

     let renderer = UIGraphicsImageRenderer(size: original.size)
     
     /**NP PROFILING - abstract shadowing when done*/
     let rounded     = renderer.image { ctx in
         ctx.cgContext.setShadow(offset: CGSize.zero, blur: 200, color: UIColor.black.cgColor)
         ctx.cgContext.fillEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
         ctx.cgContext.setShadow(offset: CGSize.zero, blur: 0, color: nil)
         
         ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
         ctx.cgContext.clip()
         
         original.draw(at: CGPoint.zero)
     }
     
     cell.imageView?.image               = rounded
     
 
//        let rounded = renderer.image { ctx in
//            ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
//            ctx.cgContext.clip()
//
//            original.draw(at: CGPoint.zero)
//        }
//
//        cell.imageView?.image = rounded
//
//        // give the images a nice shadow to make them look a bit more dramatic
//        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
//        cell.imageView?.layer.shadowOpacity = 1
//        cell.imageView?.layer.shadowRadius = 10
//        cell.imageView?.layer.shadowOffset = CGSize.zero

     /**each image stores how often it's been tapped**/
     let defaults = UserDefaults.standard
     cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"

     return cell
 }
 */
