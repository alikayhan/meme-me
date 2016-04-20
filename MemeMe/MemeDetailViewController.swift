//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Ali Kayhan on 20/04/16.
//  Copyright © 2016 Ali Kayhan. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
// MARK: - Outlets

    @IBOutlet weak var memeDetailImage: UIImageView!
    

// MARK: - Properties
    
    var meme: Meme!
    
    
// MARK: - Lifecycle Functions
    
    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = true
        memeDetailImage.image = meme.memedImage
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
        navigationController?.hidesBarsOnTap = false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
