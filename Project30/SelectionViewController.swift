//
//  SelectionViewController.swift
//  Project30-BugDetective
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController
{
    /**this is the array that will store the filenames to load**/
	var items           = [String]()
	var dirty           = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setTableView()
        loadJPEGsIntoArray()
    }

    
	override func viewWillAppear(_ animated: Bool)
    {
		super.viewWillAppear(animated)
        /**we've been marked as needing a counter reload, so reload the whole table**/
		if dirty { tableView.reloadData() }
	}
    
    
    func setTableView()
    {
        title                       = "Reactionist"
        tableView.rowHeight         = 90
        tableView.separatorStyle    = .none
    }
    
    
    func loadJPEGsIntoArray()
    {
        /**load all the JPEGs into our array**/
        let fm              = FileManager.default
        guard let path      = Bundle.main.resourcePath else { print("nil found @ resourcePath"); return }
        
        if let tempItems    = try? fm.contentsOfDirectory(atPath: path) {
            for item in tempItems {
                if item.range(of: "Large") != nil { items.append(item) }
            }
        }

    }

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count * 10
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil { cell = UITableViewCell(style: .default, reuseIdentifier: "Cell") }

		/**find the img for this cell, and load its thumbnail**/
		let currentImage    = items[indexPath.row % items.count]
		let imageRootName   = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
        guard let path      = Bundle.main.path(forResource: imageRootName, ofType: nil) else { return cell }
        guard let original  = UIImage(contentsOfFile: path) else { return cell }
        
        /**making the render rectangle the size of the tableView row height so img sizes don't conflict w said height**/
        let renderRect      = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        let renderer        = UIGraphicsImageRenderer(size: renderRect.size)
        
        let rounded         = renderer.image { ctx in
            #warning("why does removing .addEllipse result in clip: empty path soft error?")
            ctx.cgContext.addEllipse(in: renderRect)
            #warning("not too sure what .clip is doing, & why it only works w .addEllipse")
            /**hint: the ellipse doesn't get read as a circle until we add .clip - all I see are squares until .clip is involved**/
            ctx.cgContext.clip()
            original.draw(in: renderRect)
        }
        
        cell.imageView?.image               = rounded
        
        /**give the imgs a  shadow**/
        #warning("note how this resembles the 1st model as it sits outside of the ctx")
        #warning("once it's fixed, test in the sim debugger to see how yellow over shadow is gone after you draw the shadow this way, compare to old code & how yellow overlaps the shadow")
        cell.imageView?.layer.shadowColor   = UIColor.black.cgColor
        cell.imageView?.layer.shadowOpacity = 1
        cell.imageView?.layer.shadowRadius  = 10
        cell.imageView?.layer.shadowOffset  = CGSize.zero
        cell.imageView?.layer.shadowPath    = UIBezierPath(ovalIn: renderRect).cgPath
        
		/**each image stores how often it's been tapped**/
		let defaults        = UserDefaults.standard
		cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"

		return cell
    }

    
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
		let vc      = ImageViewController()
		vc.image    = items[indexPath.row % items.count]
		vc.owner    = self

		/**mark us as not needing a counter reload when we return**/
		dirty       = false
        navigationController?.pushViewController(vc, animated: true)
	}
}
