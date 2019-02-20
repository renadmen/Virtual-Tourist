//
//  CollectionViewController.swift
//  Virtuak-Tourist-Renad
//
//  Created by renad saleh on 17/02/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreData
import SystemConfiguration
import MapKit



private let reuseIdentifier = "Cell"

class CollectionViewController: FlickrApi,
UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    let noDataLabel: UILabel = UILabel()
    
    
    var photoFetchedResultsController:NSFetchedResultsController<Photo>!
    
    fileprivate func setupFetchedResultsController() {

        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        photoFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        try! photoFetchedResultsController.performFetch()
        pinPhotos.removeAll()
        self.pinPhotos = Array(repeating:nil, count:Int(pin.numberOfPhotos))
        collectionView.reloadData()
        var counter = 0
        for photo in photoFetchedResultsController.fetchedObjects!{
            pinPhotos[counter] = photo
            counter += 1
            collectionView.reloadData()
        }
        
        if counter == Int(pin.numberOfPhotos){
            isDownloading = false
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            collectionView.reloadData()
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNoDataLabel()

        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "New Collection", style: .plain, target: self, action: #selector(RetrieveNewCollection)), animated: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(SaveOrSharePhoto(touch:)))
        self.collectionView?.addGestureRecognizer(longGesture)
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupFetchedResultsController()
        if pinPhotos.isEmpty{
            downloadImages()
        }
        self.collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        photoFetchedResultsController = nil
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(pin.numberOfPhotos)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 8
        return CGSize(width: width/3, height: width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        // Configure the cell
        
        let activityIndicator = cell.startAnActivityIndicator()
        noDataLabel.removeFromSuperview()

        if ( isConnectedToNetwork() == true) {
            
        }else {
            self.showAlert(title: "My App", msg: "Plese connect to the internet and try again", actions: nil)
            
        }
        
        if pinPhotos[indexPath.row]?.photo != nil{
            let photoData = pinPhotos[indexPath.row]!.photo!
            cell.photoImageView.image = UIImage(data: photoData)



        } else{
            cell.photoImageView.image = nil

        }
        if cell.photoImageView.image != nil && isDownloading == false{
            activityIndicator.stopAnimating()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isDownloading == false{
            let photoToBeDeleted = photoFetchedResultsController.object(at: indexPath)
            dataController.viewContext.delete(photoToBeDeleted)
            pin.numberOfPhotos -= 1
            try? dataController.viewContext.save()
            self.setupFetchedResultsController()
        }
    }
    
    
    @objc func SaveOrSharePhoto(touch: UILongPressGestureRecognizer) {
        
        let point = touch.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        if let index = indexPath{
            if touch.state == .began {
                let activityVC = UIActivityViewController(activityItems: [UIImage(data: (pinPhotos[index.row]?.photo)!)], applicationActivities: nil)
                activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                    if !completed {
                        return
                    }
                    else{
                        self.dismiss(animated: true, completion: nil)
                        self.showToast(message: "Saved!")
                    }
                }
                present(activityVC, animated: true)
            }
        }
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-300, width: 150, height: 50))
        toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func searchByLatLon(){
        let methodParameters = [
            "method": "flickr.photos.search",
            "api_key": "e6784206d95bd25f07da662d07c5af9e",
            "bbox": bboxString(),
            "safe_search": "safe_search",
            "extras": "url_m",
            "format": "json",
            "nojsoncallback": "1"
        ]
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        isDownloading = true
        displayImageFromFlickrBySearch(methodParameters as [String:AnyObject]){(success) -> Void  in
            DispatchQueue.main.async {
                self.setupFetchedResultsController()
            }
        }
    }
    
    func downloadImages(){
        searchByLatLon()
        collectionView.reloadData()
    }
    
    @objc func RetrieveNewCollection(sender:UIButton!) {
            for object in photoFetchedResultsController.fetchedObjects!{
                dataController.viewContext.delete(object)
            }
            try! dataController.viewContext.save()
            downloadImages()
        
        
    }
    
    
    func setNoDataLabel() {
        noDataLabel.text = "No Photos Yet"
        noDataLabel.frame.size.width = self.view.frame.width
        noDataLabel.frame.size.height = 30
        noDataLabel.textAlignment = .center
        noDataLabel.center.x = self.view.frame.width/2
        noDataLabel.center.y = self.view.frame.height/2 - (self.navigationController?.navigationBar.frame.height)!
        noDataLabel.textColor = UIColor.gray
        self.view.addSubview(noDataLabel)
    }
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
    }
    
    func showAlert(title: String, msg: String, actions:[UIAlertAction]?) {
        
        var actions = actions
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        if actions == nil {
            actions = [UIAlertAction(title: "OK", style: .default, handler: nil)]
        }
        
        for action in actions! {
            alertVC.addAction(action)
        }
        
        if let rootVC = UIApplication.shared.delegate?.window??.rootViewController {
            rootVC.present(alertVC, animated: true, completion: nil)
        } else {
            print("Root view controller is not set.")
        }
    }
}
