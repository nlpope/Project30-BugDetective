//
//  SelectionViewController.swift
//  Project30-BugDetective
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//  img resizing: https://nshipster.com/image-resizing/

import UIKit

class SelectionViewController: UITableViewController
{
    /**this is the array that will store the filenames to load**/
	var items      = [String]()
    var images     = [UIImage]()
	var dirty           = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setTableView()
        loadJPEGsIntoArrays()
    }

    
	override func viewWillAppear(_ animated: Bool)
    {
		super.viewWillAppear(animated)
		if dirty { tableView.reloadData() }
	}
    
    
    func setTableView()
    {
        title                       = "Reactionist"
        tableView.rowHeight         = CellRows.height
        tableView.separatorStyle    = .none
    }
    
    
    func loadJPEGsIntoArrays()
    {
        let fm              = FileManager.default
        guard let path      = Bundle.main.resourcePath else { print("nil found @ resourcePath"); return }
        
        if let tempItems    = try? fm.contentsOfDirectory(atPath: path) {
            for item in tempItems {
                if item.range(of: "Large") != nil {
                    items.append(item)
                    let resizedItem = item.convertToImage(atSize: CGSize(width: 55, height: 55))
                    images.append(resizedItem!)
                }
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

		let currentImage    = items[indexPath.row % items.count]
        let currentSmallImage   = images[indexPath.row % images.count]
        
        cell.imageView?.image               = images[indexPath.row % images.count]
        
        /**give the images a  shadow**/
        cell.imageView?.layer.shadowColor   = UIColor.black.cgColor
        cell.imageView?.layer.shadowOpacity = 1
        cell.imageView?.layer.shadowRadius  = 10
        cell.imageView?.layer.shadowOffset  = CGSize.zero
        //renderrect = cgrect
//        cell.imageView?.layer.shadowPath    = UIBezierPath(ovalIn: renderRect).cgPath
        
		/**each image stores how often it's been tapped**/
		let defaults            = UserDefaults.standard
		cell.textLabel?.text    = "\(defaults.integer(forKey: currentImage))"

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
