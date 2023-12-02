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
        return 4
    }
    
    // MARK: code for each cell and row
    
    func tableView(_ bookDetailTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return book.volumeInfo.authors?.count ?? 1
        case 2:
            return book.volumeInfo.categories?.count ?? 1
        default:
            return 1
        }
    }
    
    func tableView(_ bookDetailTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //let cell = bookDetailTableView.dequeueReusableCell(withIdentifier: "book", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "book")
        // makes sure this cells can no longer be clicked
        cell.selectionStyle = .none
        // makes sure text doesn't overflow if not enough lines
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel?.text = book.volumeInfo.title
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
            }
            else {
                let coverCell = CoverTableViewCell(reuseIdentifier: "coverCell")
                // makes sure cover image link exists
                let safeURL = book.volumeInfo.imageLinks?.thumbnail ?? ""
                if (safeURL != "") {
                    coverCell.loadImage(url: URL(string: safeURL)!)
                }
                else {
                    coverCell.coverImageView.image = UIImage(imageLiteralResourceName: "Noimage")
                }
                coverCell.selectionStyle = .none
                return coverCell
            }
        }
        else if (indexPath.section == 1) {
            // make sure authors exist
            if (book.volumeInfo.authors?.count == nil) {
                cell.textLabel?.text = "Unknown"
            }
            else {
                cell.textLabel?.text = book.volumeInfo.authors?[indexPath.row]
            }
        }
        else if (indexPath.section == 2) {
            // make sure categories exist
            if (book.volumeInfo.categories?.count == nil) {
                cell.textLabel?.text = "Unknown"
            }
            else {
                cell.textLabel?.text = book.volumeInfo.categories?[indexPath.row]
            }
        }
        else {
            cell.textLabel?.text = book.volumeInfo.description ?? "No description available"
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
    
    // MARK: header of each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 1) {
            return "Authors"
        }
        if (section == 2) {
            return "Genre"
        }
        if (section == 3) {
            return "Description"
        }
        return nil
    }
}
