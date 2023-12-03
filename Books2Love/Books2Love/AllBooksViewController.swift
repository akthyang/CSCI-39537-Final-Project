//
//  AllBooksViewController.swift
//  Books2Love
//
//  Created by Alicia Yang on 11/20/23.
//  MARK: Displays a list of books and lightnovels

import UIKit

class AllBooksViewController: UIViewController {

    var bookSections = ["Popular Young Adult Books", "Lightnovels"]
    var books = [Book]()
    var lightnovels = [Book]()
    
    lazy var AllBooksTableView: UITableView = {
        let AllBooksTableView = UITableView()
        AllBooksTableView.dataSource = self
        AllBooksTableView.delegate = self
        return AllBooksTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Library"
        view.addSubview(AllBooksTableView)
        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 0.95)
        
        // calls the GoogleBook API
        Task {
            do {
                let books = try await BooksAPI.shared.popularBooksWest()
                self.books = books
                let lightnovels = try await BooksAPI.shared.lightNovels()
                self.lightnovels = lightnovels
                AllBooksTableView.reloadData()
            }
            catch {
                print(error)
            }
        }
    }
    
    // MARK: makes sure table remains in the frame of the phone
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        AllBooksTableView.frame = view.bounds
    }
}


// MARK: TableView Delegate and Data Source
extension AllBooksViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: code for the header of each section
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let heading = UILabel()
        heading.textColor = .black
        heading.text = bookSections[section]
        heading.textAlignment = .center
        heading.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 0.95)
        heading.font = .systemFont(ofSize: 25)
        heading.numberOfLines = 0
        heading.lineBreakMode = .byWordWrapping
        return heading
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return bookSections.count
    }
    
    // MARK: Code for each cell
    
    func tableView(_ AllBooksTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ AllBooksTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BooksTableViewCell(style: .default, reuseIdentifier: "bookCell")
        var book = books[indexPath.row]
        // changes value of book if section changes
        if (indexPath.section == 1) {
            book = lightnovels[indexPath.row]
        }
        // makes sure an image cover link exists
        let safeURL = book.volumeInfo.imageLinks?.thumbnail ?? ""
        if (safeURL != "") {
            cell.thumbnail.loadImage(url: URL(string: safeURL)!)
        }
        else {
            cell.thumbnail.image = UIImage(imageLiteralResourceName: "Noimage")
        }
        cell.bookTitle.text = book.volumeInfo.title
        cell.descript.text = String(removeHTMLTags(str: book.searchInfo?.textSnippet ?? "Opps. There is currently no short description available").characters)
        return cell
    }
    
    // MARK: changes view when a cell is selected to display the book's details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var book = books[indexPath.row]
        if (indexPath.section == 1) {
            book = lightnovels[indexPath.row]
        }
        let detailsViewCountroller = BookDetailsViewController(book: book)
        navigationController?.pushViewController(detailsViewCountroller, animated: true)
    }
    
    func tableView(_ AllBooksTableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    // MARK: helper function to remove HTML tags
    // Source Code: https://www.appsloveworld.com/swift/100/426/how-to-remove-html-tags-from-received-json-data-that-is-shown-in-swiftuis-list-v
    func removeHTMLTags(str: String) -> AttributedString {
        if let theData = str.data(using: .utf16) {
            do {
                let theString = try NSAttributedString(data: theData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                return AttributedString(theString)
            } catch {  print("\(error)")  }
        }
        return AttributedString(str)
    }
    
}
