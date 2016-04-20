//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Ali Kayhan on 19/04/16.
//  Copyright © 2016 Ali Kayhan. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
// MARK: - Properties
    
    var memes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
// MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        // If no meme has been created yet, the application will start with Meme Editor view.
        if memes.count == 0 {
            let initialViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNavigationController") as! UINavigationController
            presentViewController(initialViewController, animated: false, completion: nil)
        } else {
        tableView.reloadData()
        }
    }


// MARK: - Table View Data Source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemesTableViewCell")!
        
        // Cell configuration
        cell.textLabel?.text = (memes[indexPath.row].topText + " ... " + memes[indexPath.row].bottomText)
        cell.imageView?.image = memes[indexPath.row].memedImage
        
        // Cell image view settings for fixed size images on table
        let imageSize = CGSizeMake(108.0, 81.0)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.mainScreen().scale)
        let imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height)
        cell.imageView?.image?.drawInRect(imageRect)
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return cell
    }
    

// MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailViewController.meme = memes[indexPath.row]
        
        navigationController?.pushViewController(memeDetailViewController, animated: true)
    }

}
