//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Ali Kayhan on 19/04/16.
//  Copyright © 2016 Ali Kayhan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemesCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {
    
// MARK: - Outlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
// MARK: - Properties
    
    var memes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    // Constants for setting the flow layout
    let spaceBetweenMemeCells: CGFloat = 2.0
    let memesInARow = 3
    
    
// MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if memes.count == 0 {
            let initialViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNavigationController") as! UINavigationController
            presentViewController(initialViewController, animated: false, completion: nil)
        } else {
            flowLayout = setupFlowLayout(spaceBetweenMemeCells, memesInARow: memesInARow)
            
            collectionView?.backgroundColor = UIColor.whiteColor()
            collectionView?.reloadData()
        }
    }
    
    // This function invalidates the current layout when the device is changed to landscape
    // from portrait or vice versa.
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        flowLayout?.invalidateLayout()
    }
    
    
// MARK: - Flow Layout Functions
    
    // This function is automatically called when the current flow layout is invalidated and
    // sets a new cell size appropriate to device's new orientation.
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return setupFlowLayout(spaceBetweenMemeCells, memesInARow: memesInARow).itemSize
    }
    
    // Helper function for setting flow layout up
    func setupFlowLayout(spaceBetweenMemeCells: CGFloat, memesInARow: Int) -> UICollectionViewFlowLayout {
        let dimension = (view.frame.size.width - ((CGFloat(memesInARow - 1)) * spaceBetweenMemeCells)) / CGFloat(memesInARow)
        
        flowLayout.minimumLineSpacing = spaceBetweenMemeCells
        flowLayout.minimumInteritemSpacing = spaceBetweenMemeCells
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        return flowLayout
    }
    
    
// MARK: - Collection View Data Source

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SentMemesCollectionViewCell
    
        // Cell configuration
        cell.cellImage.contentMode = .ScaleAspectFit
        cell.backgroundColor = UIColor.grayColor()
        cell.cellImage.image = memes[indexPath.item].memedImage
    
        return cell
    }
    
    
// MARK: - Collection View Delegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let memeDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailViewController.meme = memes[indexPath.item]
        
        navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
    
}
