//
//  AllBooksViewController.swift
//  Books2Love
//
//  Created by Alicia Yang on 11/20/23.
//  MARK: Displays a list of books and lightnovels

import UIKit

class AllBooksViewController: UIViewController {

    let bookCell = "bookCell"
    var books = [Book]()
    
    lazy var AllBooksTableView: UITableView = {
        let AllBooksTableView = UITableView()
        AllBooksTableView.dataSource = self
        AllBooksTableView.delegate = self
        AllBooksTableView.register(BooksTableViewCell.self, forCellReuseIdentifier: bookCell)
        return AllBooksTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(AllBooksTableView)
        
        // calls the GoogleBook API
        Task {
            do {
                let books = try await BooksAPI.shared.popularBooksWest()
                self.books = books
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
    
    // MARK: Code for each cell
    
    func tableView(_ AllBooksTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ AllBooksTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AllBooksTableView.dequeueReusableCell(withIdentifier: bookCell, for: indexPath) as! BooksTableViewCell
        let book = books[indexPath.row]
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
        let book = books[indexPath.row]
        let detailsViewCountroller = BookDetailsViewController(book: book)
        navigationController?.pushViewController(detailsViewCountroller, animated: true)
    }
    
    func tableView(_ AllBooksTableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
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
