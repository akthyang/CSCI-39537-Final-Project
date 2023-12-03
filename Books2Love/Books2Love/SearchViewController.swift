//
//  SearchViewController.swift
//  Books2Love
//
//  Created by Alicia Yang on 12/2/23.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    let searchController = UISearchController(searchResultsController: nil)
    let sections = ["Books", "Lightnovels"]
    
    var books = [Book]()
    var lightnovels = [Book]()
    var keyword = ""
    
    // displays the list of results from search
    lazy var resultsTable: UITableView = {
        let resultsTable = UITableView()
        resultsTable.dataSource = self
        resultsTable.delegate = self
        return resultsTable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Search"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter a keyword: "
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else { return }
        Task {
            do {
                view.addSubview(resultsTable)
                resultsTable.frame = view.bounds
                self.keyword = keyword
                let books = try await BooksAPI.shared.search(keyword: keyword)
                self.books = books
                resultsTable.reloadData()
            }
            catch {
                print(error)
            }
        }
    }

}

// MARK: resultsTable Delegate and Data Source
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: code for each section
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let heading = UILabel()
        heading.textColor = .black
        heading.textAlignment = .center
        heading.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 0.95)
        heading.font = .systemFont(ofSize: 25)
        heading.numberOfLines = 0
        heading.lineBreakMode = .byWordWrapping
        if (section == 0 && books.count > 0) {
            heading.text = sections[section]
            return heading
        }
        else if (section == 1 && lightnovels.count > 0) {
            heading.text = sections[section]
            return heading
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ AllBooksTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return books.count
        }
        return lightnovels.count
    }
    
    // MARK: Code for each cell
    
    func tableView(_ AllBooksTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchTableViewCell(style: .default, reuseIdentifier: "searchCell")
        var book = books[indexPath.row]
        // changes value of book if section changes
        if (indexPath.section == 1 && lightnovels.count > 0) {
            book = lightnovels[indexPath.row]
        }
        cell.bookTitle.text = book.volumeInfo.title
        // add all the authors if provided
        if (book.volumeInfo.authors?.count ?? 0 > 0) {
            cell.authors.text = book.volumeInfo.authors?.first
            if (book.volumeInfo.authors?.count ?? 0 > 1) {
                var i = 1
                while (i < book.volumeInfo.authors?.count ?? 0) {
                    cell.authors.text = cell.authors.text! + ", " + (book.volumeInfo.authors?[i])!
                    i = i + 1
                }
            }
        }
        // If there is no author listed
        else {
            cell.authors.text = "Unknown"
        }
        
        return cell
    }
    
    // MARK: changes view when a cell is selected to display the book's details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var book = books[indexPath.row]
        if (indexPath.section == 1 && lightnovels.count > 0) {
            book = lightnovels[indexPath.row]
        }
        let detailsViewCountroller = BookDetailsViewController(book: book)
        navigationController?.pushViewController(detailsViewCountroller, animated: true)
    }
    
    func tableView(_ AllBooksTableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
