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
                lightnovels = books
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
    
    // MARK: code for the header of each section
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let heading = UILabel()
        heading.textColor = .black
        heading.text = sections[section]
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
        return sections.count
    }
    
    // MARK: Code for each cell
    
    func tableView(_ AllBooksTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ AllBooksTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "bookCell")
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        var book = books[indexPath.row]
        // changes value of book if section changes
        if (indexPath.section == 1) {
            book = lightnovels[indexPath.row]
        }
        cell.textLabel?.text = book.volumeInfo.title
        
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
        return UITableView.automaticDimension
    }
    
}
