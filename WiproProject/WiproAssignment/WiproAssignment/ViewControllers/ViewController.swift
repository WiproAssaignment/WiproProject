//
//  ViewController.swift
//  WiproAssignment
//
//  Created by Nallagangula Pavan Kumar on 02/06/19.
//  Copyright © 2019 Pavan Kumar. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    private(set) var collectionView: UICollectionView

    var jsonDict: NSDictionary = [:]
    var dataArray: NSArray = []
    let indicatorView = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()

    /// ViewCOntrollerViewModel instance of ViewCOntrollerViewModel
    var viewCOntrollerViewModel = ViewCOntrollerViewModel()

    // Initializers
    init() {
        // Create new `UICollectionView` and set `UICollectionViewFlowLayout` as its layout
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Create new `UICollectionView` and set `UICollectionViewFlowLayout` as its layout
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchAllRooms()
        self.setUpCOllectionView()
        self.setUpRefreshControl()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    /// Intantiates and ViewController from StoryBoard
    ///
    /// - Returns: ViewController instance
    class func instantiateFromStoryboard() -> ViewController {
        let storyboard = UIStoryboard(name: Constants.main, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! ViewController
    }
    
    /// Set up colletion view properties
    func setUpCOllectionView() {
        // Register Cells
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: Constants.reuseId)
        
        // Add `coolectionView` to display hierarchy and setup its appearance
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // Setup Autolayout constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        // Setup `dataSource` and `delegate`
        collectionView.dataSource = self
        collectionView.delegate = self
        
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInsetReference = .fromLayoutMargins
    }

    /// To show Activity indicator view
    func showLoadingIndicator() {
        indicatorView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicatorView.center = self.view.center
        indicatorView.style = .whiteLarge
        indicatorView.hidesWhenStopped = true
        indicatorView.color = UIColor.black
        self.collectionView.addSubview(indicatorView)
        indicatorView.startAnimating()
    }
    
    /// To hide Activity indicator view
    func hideIndicatorView() {
        indicatorView.stopAnimating()
    }
    
    /// Set up Page Refresh Control
    func setUpRefreshControl() {
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
    
    /// Action method for Refresh Control
    @objc func refresh() {
        self.fetchAllRooms()
    }
    // Alamofire Web Service call
    func fetchAllRooms() {
        self.showLoadingIndicator()
        viewCOntrollerViewModel.allRommsWebServiceCall(completionHandler: { (status, jsonDict) in
            self.hideIndicatorView()
            self.refreshControl.endRefreshing()
            self.jsonDict = jsonDict ?? [:]
            if let array = jsonDict?["rows"] {
                self.dataArray = array as! NSArray
                self.collectionView.reloadData()
            }
        }) { (status, message) in
            // Alert view
        }
}
    
}

/// UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.title = self.jsonDict["title"] as? String
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseId, for: indexPath) as! ContentCollectionViewCell
        cell.configure(dict: dataArray[indexPath.row] as! NSDictionary)
        return cell
    }
    
}

/// UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
 
    
}

/// UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let referenceHeight: CGFloat = 129 // Approximate height of your cell
        let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
            - sectionInset.left
            - sectionInset.right
            - collectionView.contentInset.left
            - collectionView.contentInset.right
        return CGSize(width: referenceWidth, height: referenceHeight)
        
    }
}
