//
//  BookDetailsViewController.swift
//  Books2Love
//
//  Created by Alicia Yang on 11/20/23.
//  MARK: displays the details of book

import UIKit

class BookDetailsViewController: UIViewController {

    private let book: Book

    lazy var bookDetailTableView: UITableView = {
        let bookDetailTableView = UITableView(frame: .zero, style: .grouped)
        bookDetailTableView.register(UITableViewCell.self, forCellReuseIdentifier: "book")
        bookDetailTableView.dataSource = self
        bookDetailTableView.delegate = self
        return bookDetailTableView
    }()
    
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bookDetailTableView)
        bookDetailTableView.frame = view.bounds

        // Do any additional setup after loading the view.
    }
    

}

// MARK: TableView Delegate and Data Source
extension BookDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // MARK: code for each cell and row
    
    func tableView(_ bookDetailTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return 1
        default:
            return 2
        }
    }
    
    func tableView(_ bookDetailTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //let cell = bookDetailTableView.dequeueReusableCell(withIdentifier: "book", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "book")
        // makes sure this cells can no longer be clicked
        cell.selectionStyle = .none
        // makes sure
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        switch indexPath {
        case[0, 0]:
            cell.textLabel?.text = book.volumeInfo.title
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        case[0,1]:
            let coverCell = CoverTableViewCell(reuseIdentifier: "coverCell")
            if let safeURL = URL(string: book.volumeInfo.imageLinks.thumbnail) {
                coverCell.loadImage(url: safeURL)
            }
            else {
                coverCell.coverImageView.image = UIImage(imageLiteralResourceName: "Noimage")
            }
            coverCell.selectionStyle = .none
            return coverCell
        case[1,0]:
            cell.textLabel?.text = book.volumeInfo.authors![0]
        case[1,1]:
            cell.textLabel?.text = book.volumeInfo.categories![0]
        case[2,0]:
            cell.textLabel?.text = book.volumeInfo.description
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case[0,1]:
            // default height for cover image
            return 300
        default:
            // autoresize cell height to content
            return UITableView.automaticDimension
        }
    }
    
}
