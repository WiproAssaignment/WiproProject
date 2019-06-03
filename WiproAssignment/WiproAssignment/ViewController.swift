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

    var cellId = "Cell"
    var jsonDict: NSDictionary = [:]
    var dataArray: NSArray = []
    let url = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"

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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setUpCOllectionView() {
        // Register Cells
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: ContentCollectionViewCell.reuseId)
        
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

    // With Alamofire
    func fetchAllRooms() {
        guard let url = URL(string: url) else {
            return
        }
        Alamofire.request(url)
            .responseJSON { response in
                
                let responseStrInISOLatin = String(data: response.data!, encoding: String.Encoding.isoLatin1)
                guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                    print("could not convert data to UTF-8 format")
                    return
                }
                do {
                    let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                    print(responseJSONDict)
                    self.jsonDict = responseJSONDict as! NSDictionary
                    if let array = self.jsonDict["rows"] {
                        self.dataArray = array as! NSArray
                    }
                    self.collectionView.reloadData()
                } catch {
                    print(error)
                }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.title = self.jsonDict["title"] as? String
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.reuseId, for: indexPath) as! ContentCollectionViewCell
        cell.configure(dict: dataArray[indexPath.row] as! NSDictionary)
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
 
    
}

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
