//
//  SearchViewController.swift
//  Books2Love
//
//  Created by Alicia Yang on 12/2/23.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    let searchController = UISearchController(searchResultsController: nil)
    let sections = ["Books", "LightNovels", "Manga"]
    
    var books = [Book]()
    var novel = [Novels]()
    var manga = [Manga]()
    var keyword = ""
    
    // displays the list of results from search
    lazy var resultsTable: UITableView = {
        let resultsTable = UITableView()
        resultsTable.dataSource = self
        resultsTable.delegate = self
        resultsTable.frame = view.bounds
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
        DispatchQueue.main.async {
            Task {
                do {
                    self.keyword = keyword
                    // creates a loading page until table has finished loading
                    let loading = LoadingViewController()
                    loading.label.text = "Searching in our database..."
                    self.navigationController?.pushViewController(loading, animated: false)
                    // removes back button on top
                    self.navigationController?.navigationBar.isHidden = true
                    
                    let books = try await BooksAPI.shared.search(keyword: keyword)
                    self.books = books
                    let manga = try await MangaAPI.shared.search(keyword: keyword)
                    self.manga = manga
                    let novel = try await LightNovelAPI.shared.search(keyword: keyword)
                    self.novel = novel
                    
                    // removes loading page once table has loaded
                    self.navigationController?.popViewController(animated: false)
                    self.navigationController?.navigationBar.isHidden = false
                    
                    self.view.addSubview(self.resultsTable)
                    self.resultsTable.reloadData()
                }
                catch {
                    print(error)
                }
            }
        }
    }

}

// MARK: resultsTable Delegate and Data Source
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: code for each section
    
    func tableView(_ resultsTable: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ resultsTable: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in resultsTable: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ resultsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return books.count
        }
        else if (section == 1 && novel.count > 0) {
            return novel.count
        }
        else if (section == 2 && manga.count > 0) {
            return manga.count
        }
        return 1
    }
    
    // MARK: Code for each cell
    
    func tableView(_ resultsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchTableViewCell(style: .default, reuseIdentifier: "searchCell")
        if (indexPath.section == 0) {
            let book = books[indexPath.row]
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
        }
        else if (indexPath.section == 1) {
            if (novel.count > 0) {
                let novel = novel[indexPath.row]
                cell.bookTitle.text = novel.title.capitalized
                cell.authors.text = novel.novelInfo?.novel.author.replacingOccurrences(of: "：", with: "") ?? "Unknown"
            }
            else {
                cell.textLabel?.text = "None available."
                cell.selectionStyle = .none
            }
        }
        else {
            if (manga.count > 0) {
                let manga = manga[indexPath.row]
                cell.bookTitle.text = manga.attributes.canonicalTitle
                if (manga.authors?.count ?? 0 > 0) {
                    cell.authors.text = manga.authors?.first
                    if (manga.authors?.count ?? 0 > 1) {
                        var i = 1
                        while (i < manga.authors?.count ?? 0) {
                            cell.authors.text = cell.authors.text! + ", " + (manga.authors?[i])!
                            i = i + 1
                        }
                    }
                }
                // If there is no author listed
                else {
                    cell.authors.text = "Unknown"
                }
            }
            else {
                cell.textLabel?.text = "None available."
                cell.selectionStyle = .none
            }
        }
        
        return cell
    }
    
    // MARK: changes view when a cell is selected to display the book's details
    
    func tableView(_ resultsTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            let book = books[indexPath.row]
            let detailsViewCountroller = BookDetailsViewController(book: book)
            navigationController?.pushViewController(detailsViewCountroller, animated: true)
        }
        else if (indexPath.section == 1 && novel.count > 0) {
            let novel = novel[indexPath.row]
            let detailsViewCountroller = NovelDetailsViewController(novel: novel)
            navigationController?.pushViewController(detailsViewCountroller, animated: true)
        }
        else if (indexPath.section == 2 && manga.count > 0) {
            let manga = manga[indexPath.row]
            let detailsViewCountroller = MangaDetailsViewController(manga: manga)
            navigationController?.pushViewController(detailsViewCountroller, animated: true)
        }
    }
    
    func tableView(_ resultsTable: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
