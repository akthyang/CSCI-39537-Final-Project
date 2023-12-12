//
//  CoverTableViewCell.swift
//  Books2Love
//
//  Created by Alicia Yang on 11/20/23.
//  MARK: custom cell to display book cover img

import UIKit

class CoverTableViewCell: UITableViewCell {

    let coverImageView: UIImageView
    
    private var coverSize: CGSize {
        CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    init(reuseIdentifier: String?) {
        self.coverImageView = UIImageView()
        self.coverImageView.contentMode = .scaleAspectFill
        self.coverImageView.layer.masksToBounds = true
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.contentView.layer.masksToBounds = true
        
        self.contentView.addSubview(self.coverImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(url: URL) {
        coverImageView.loadImage(url: url)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    // formats the contents inside the view cell
    override func layoutSubviews() {
        super.layoutSubviews()
        // x represents the padding from left
        // y represents the padding from top
        coverImageView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: coverSize.width,
                                      height: coverSize.height)
    }
    
}
