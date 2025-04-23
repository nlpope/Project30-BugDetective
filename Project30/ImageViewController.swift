//
//  ImageViewController.swift
//  Project30-BugDetective
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController
{
	weak var owner: SelectionViewController!
	var image: String!
	var animTimer: Timer!
	var imageView: UIImageView!

	override func loadView()
    {
		super.loadView()
        setViewBackground()
        createImageView()
        animateImageViewScale()
	}

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setViewTitle()
        drawImageView()
    }

    
	override func viewDidAppear(_ animated: Bool)
    {
		super.viewDidAppear(animated)
        setImageViewTransparency()
        animateImageViewTransparency()
	}
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        animTimer.invalidate()
    }
    
    
    //-------------------------------------//
    // MARK: ENVIRONMENT SET UP
    
    func setViewBackground() { view.backgroundColor = UIColor.black }
    
    
    func setViewTitle() { title = image.replacingOccurrences(of: "-Large.jpg", with: "") }
    
    //-------------------------------------//
    // MARK: IMAGE SET UP
    
    func createImageView()
    {
        /**create an image view that fills the screen**/
        imageView               = UIImageView()
        imageView.contentMode   = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha         = 0

        view.addSubview(imageView)

        /**make the image view fill the screen**/
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    #warning("why is this necessary, the img isn't round")
    func drawImageView()
    {
        /**
         let original    = UIImage(named: image)!
         
         UIImage(named:) caches images for reuse later so they don't have to spend time getting
         called at a later time. However, these images aren't expected to have too many repeat views
         e.g. the user backing out of the detailVC then directly back into it. So use
         
         let original = UIImage(contentsOfFile:)
         
         This will not cache the image, but mark the data as PURGEABLE. If the data is purged and needs to be reloaded, the image object loads that data again from the specified path, which takes (insignificantly) longer than reaching for a cached image via the previous method
         **/
        
        let path        = Bundle.main.path(forResource: image, ofType: nil)!
        
        let original    = UIImage(contentsOfFile: path)!

        let renderer    = UIGraphicsImageRenderer(size: original.size)

        let rounded     = renderer.image { ctx in
            ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
            ctx.cgContext.closePath()
            original.draw(at: CGPoint.zero)
        }

        imageView.image = rounded
    }
    
    
    func setImageViewTransparency() { imageView.alpha = 0 }
    
    //-------------------------------------//
    // MARK: IMAGE ANIMATIONS
    
    func animateImageViewScale()
    {
        /**schedule an animation that does something vaguely interesting**/
        animTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            /**do something exciting with our image**/
            self.imageView.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 3) { self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) }
        }
    }
    
    #warning("why is this necessary, the img view isn't visible @ the end")
    func animateImageViewTransparency()
    {
        UIView.animate(withDuration: 3) { [unowned self] in
            self.imageView.alpha = 1
        }
    }

    //-------------------------------------//
    // MARK: SCREEN TAP RESPONSE METHODS
    
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
		let defaults    = UserDefaults.standard
		var currentVal  = defaults.integer(forKey: image)
		currentVal += 1

		defaults.set(currentVal, forKey:image)

		/**tell the parent view controller that it should refresh its table counters when we go back**/
		owner.dirty     = true
	}
}
