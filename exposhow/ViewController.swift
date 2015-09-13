//
//  ViewController.swift
//  exposhow
//
//  Created by Ulitka on 12.09.15.
//  Copyright (c) 2015 Ampullarius. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var scrollView: UIScrollView!
    var imageMap: ImageMap!
    var pavilions: PavilionsMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pavilions = PavilionsMap()
        
        imageMap = ImageMap(imageName: "map.png")
        imageMap.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageMapTapped:"))
        
        let taptap = UITapGestureRecognizer( target: self, action: "doubleTapZoom:")
        taptap.numberOfTapsRequired = 2
        imageMap.addGestureRecognizer(taptap)
        
        scrollView.addSubview(imageMap)
        scrollView.contentSize = imageMap.bounds.size
    }
    
    override func viewDidLayoutSubviews() {
        let scaleWidth = scrollView.frame.width / imageMap.bounds.width
        let scaleHeight = scrollView.frame.height / imageMap.bounds.height
        let minScale = max(scaleWidth, scaleHeight);
        
        scrollView.minimumZoomScale = minScale;
        scrollView.zoomScale = minScale;
    }
    
    func doubleTapZoom(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            let point = sender.locationInView(imageMap)
            
            let width = scrollView.frame.width / (scrollView.zoomScale + 0.1)
            let height = scrollView.frame.height / (scrollView.zoomScale + 0.1)
            
            let zoomRect = CGRect(
                x: point.x - width / 2.0,
                y: point.y - height / 2.0,
                width: width,
                height: height
            )
            
            scrollView.zoomToRect(zoomRect, animated: true)
        }
    }
    
    func imageMapTapped(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            let point = sender.locationInView(imageMap)
            if let i = pavilions.indexOfPavilionAtPoint(point) {
                let p = pavilions[i]
                imageMap.hightlight( p.position )
                let ip = NSIndexPath(forRow: i, inSection: 0)
                tableView.selectRowAtIndexPath(ip, animated: true, scrollPosition: .Middle)
            }
        }
    }
    
    // MARK: scroll view delegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageMap
    }

    func scrollViewDidEndScrollingAnimation(sView: UIScrollView) {
        if sView == tableView {
            if let ip = tableView.indexPathForSelectedRow() {
                tableView.deselectRowAtIndexPath(ip, animated: true)
            }
        }
    }
    
    // MARK: table view delegate and data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pavilions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PavilionCell", forIndexPath: indexPath) as! UITableViewCell
        
        let p = pavilions[indexPath.row]
        cell.textLabel?.text = p.name
        cell.detailTextLabel?.text = p.pavilion
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let p = pavilions[indexPath.row]
        imageMap.hightlight(p.position)

        var scaledRect = p.position
        scaledRect.origin.x *= scrollView.zoomScale
        scaledRect.origin.y *= scrollView.zoomScale
        scaledRect.size.width *= scrollView.zoomScale
        scaledRect.size.height *= scrollView.zoomScale
        
        let centeredRect = CGRect(
            x: scaledRect.midX - scrollView.frame.width/2.0,
            y: scaledRect.midY - scrollView.frame.height/2.0,
            width: scrollView.frame.width,
            height: scrollView.frame.height
        )
        
        scrollView.scrollRectToVisible(centeredRect, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

