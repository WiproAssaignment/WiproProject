//
//  ContentCollectionViewCell.swift
//  WiproAssignment
//
//  Created by Nallagangula Pavan Kumar on 02/06/19.
//  Copyright © 2019 Pavan Kumar. All rights reserved.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
  
    static let reuseId = "ContentCollectionViewCell"
    private let titleLabel: UILabel = UILabel(frame: .zero)
    private let messageLabel: UILabel = UILabel(frame: .zero)
    private let profileImageView: UIImageView = UIImageView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1.0
        
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        
        self.setUpProfileImageView()
        self.setUpTitleLabel()
        self.setUpMessageLabel()
    }
    
    /// Method used to set up the profile image view with constraints
    func setUpProfileImageView() {
        contentView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor, constant: 0).isActive = true
    }
    
    /// Method used to set up the title label with constraints
    func setUpTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 160).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
    }
    
    
    /// Method used to set up the message label with constraints
    func setUpMessageLabel() {
        
        let labelInset = UIEdgeInsets(top: 195, left: 10, bottom: -10, right: -10)
        contentView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: labelInset.top).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: labelInset.left).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: labelInset.right).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: labelInset.bottom).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards are quicker, easier, more seductive. Not stronger then Code.")
    }
    
    func configure(dict: NSDictionary) {

        if dict["description"] as? String != "" {
            messageLabel.text = dict["description"] as? String
        }
        if dict["title"] as? String != "" {
            titleLabel.text = dict["title"] as? String
        }
        if dict["imageHref"] as? String != "" {
            let url = dict["imageHref"] as? String
            profileImageView.imageFromServerURL(urlString: url ?? "")
        }

    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        messageLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
}
