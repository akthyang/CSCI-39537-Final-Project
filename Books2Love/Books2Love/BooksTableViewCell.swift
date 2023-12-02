//
//  BooksTableViewCell.swift
//  Books2Love
//
//  Created by Alicia Yang on 11/20/23.
//  MARK: design of cell for AllBooksViewController

import UIKit

class BooksTableViewCell: UITableViewCell {

    // MARK: the 3 items this BooksTableViewCell contains
    let thumbnail: UIImageView = {
        let thumbnail = UIImageView()
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        thumbnail.layer.masksToBounds = true

        return thumbnail
    }()
    
    let bookTitle: UILabel = {
        let bookTitle = UILabel()
        bookTitle.textColor = .black
        bookTitle.numberOfLines = 0
        bookTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        bookTitle.font = UIFont.preferredFont(forTextStyle: .title2)
        return bookTitle
    }()
    
    let descript: UILabel = {
        let descript = UILabel()
        descript.textColor = .black
        descript.numberOfLines = 0
        descript.lineBreakMode = NSLineBreakMode.byWordWrapping
        return descript
    }()
    
    // MARK: the initialization of the cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        contentView.layer.borderWidth = 1.5
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(self.thumbnail)
        contentView.addSubview(self.bookTitle)
        contentView.addSubview(self.descript)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: formats the contents inside the view cell
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // creates spacing between each table cell
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        // x represents the padding from left
        // y represents the padding from top
        thumbnail.frame = CGRect(x: 0,
                                 y: 0,
                                 width: Int(contentView.frame.width),
                                 height: 150)
        bookTitle.frame = CGRect(x: 10,
                                 y: Int(thumbnail.frame.height) + 10,
                                 width: Int(contentView.frame.width) - 10,
                                 height: 30)
        descript.frame = CGRect(x: 10,
                                y: Int(thumbnail.frame.height) + Int(bookTitle.frame.height) + 10,
                                width: Int(contentView.frame.width) - 15,
                                height: Int(contentView.frame.height) - Int(thumbnail.frame.height) - Int(bookTitle.frame.height))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
