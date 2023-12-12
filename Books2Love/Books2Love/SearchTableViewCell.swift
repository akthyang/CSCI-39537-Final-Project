//
//  SearchTableViewCell.swift
//  Books2Love
//
//  Created by Alicia Yang on 12/3/23.
//  MARK: the custom cell for Search results

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    let bookTitle: UILabel = {
        let bookTitle = UILabel()
        bookTitle.textColor = .black
        bookTitle.numberOfLines = 0
        bookTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        bookTitle.font = .systemFont(ofSize: 20, weight: .semibold)
        return bookTitle
    }()
    
    let authors: UILabel = {
        let authors = UILabel()
        authors.textColor = .black
        authors.numberOfLines = 0
        authors.lineBreakMode = NSLineBreakMode.byWordWrapping
        return authors
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.contentView.layer.masksToBounds = true
        
        self.contentView.addSubview(self.bookTitle)
        self.contentView.addSubview(self.authors)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // formats the contents inside the view cell
    override func layoutSubviews() {
        super.layoutSubviews()
        // x represents the padding from left
        // y represents the padding from top
        bookTitle.frame = CGRect(x: 10,
                                 y: 10,
                                 width: Int(contentView.frame.width) - 15,
                                 height: 50)
        authors.frame = CGRect(x: 10,
                               y: 50,
                               width: Int(contentView.frame.width) - 15,
                               height: Int(contentView.frame.height) - Int(bookTitle.frame.height) - 10)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
