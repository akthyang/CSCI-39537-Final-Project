//
//  MangaDetailsViewController.swift
//  Books2Love
//
//  Created by Alicia Yang on 12/4/23.
//  MARK: displays the details of each manga

import UIKit

class MangaDetailsViewController: UIViewController {

    private let manga: Manga
    
    // only applicable on Book of Day Page
    var heading: String = ""

    lazy var mangaDetailTableView: UITableView = {
        let mangaDetailTableView = UITableView(frame: .zero, style: .grouped)
        mangaDetailTableView.register(UITableViewCell.self, forCellReuseIdentifier: "book")
        mangaDetailTableView.dataSource = self
        mangaDetailTableView.delegate = self
        return mangaDetailTableView
    }()
    
    init(manga: Manga) {
        self.manga = manga
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(mangaDetailTableView)
        mangaDetailTableView.frame = view.bounds
    }
    

}

// MARK: TableView Delegate and Data Source

extension MangaDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: header of each section
    
    func tableView(_ mangaDetailTableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // only applies for BoD page
        if (section == 0 && heading != "") {
            return heading
        }
        else if (section == 1) {
            return "Also Goes By"
        }
        else if (section == 2) {
            return "Author/Artist"
        }
        else if (section == 3) {
            return "Genre/Category"
        }
        else if (section == 4) {
            return "Status"
        }
        else if (section == 5) {
            return "Rating"
        }
        else if (section == 6) {
            return "Description"
        }
        return nil
    }
    
    // MARK: code for each section
    
    func numberOfSections(in mangaDetailTableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ mangaDetailTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 2
        }
        else if (section == 1) {
            var i = 0
            while (i < manga.attributes.abbreviatedTitles?.count ?? 0) {
                if (manga.attributes.abbreviatedTitles?[i] == manga.attributes.titles.en_us ||
                    manga.attributes.abbreviatedTitles?[i] == manga.attributes.titles.en_jp ||
                    manga.attributes.abbreviatedTitles?[i] == manga.attributes.titles.en) {
                    return manga.attributes.abbreviatedTitles?.count ?? 0
                }
                i = i + 1
            }
            return ((manga.attributes.abbreviatedTitles?.count ?? 0) + 1)
        }
        else if (section == 2) {
            if (manga.authors?.count == 0) {
                return 1
            }
            return manga.authors!.count
        }
        else if (section == 3) {
            if (manga.genres?.count == 0) {
                return 1
            }
            return manga.genres!.count
        }
        return 1
    }
    
    // MARK: code for each cell and row
    
    func tableView(_ mangaDetailTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
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
                cell.textLabel?.text = manga.attributes.canonicalTitle
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
            }
            else {
                let coverCell = CoverTableViewCell(reuseIdentifier: "coverCell")
                // makes sure cover image link exists
                let safeURL = manga.attributes.posterImage.original
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
            if (indexPath.row < manga.attributes.abbreviatedTitles?.count ?? 0) {
                cell.textLabel?.text = manga.attributes.abbreviatedTitles?[indexPath.row]
            }
            else {
                if (manga.attributes.titles.ja_jp != nil) {
                    cell.textLabel?.text = manga.attributes.titles.ja_jp
                }
                else if (manga.attributes.titles.en_jp != nil) {
                    cell.textLabel?.text = manga.attributes.titles.en_jp
                }
                else if (manga.attributes.titles.en_us != nil) {
                    cell.textLabel?.text = manga.attributes.titles.en_us
                }
                else if (manga.attributes.titles.zh_cn != nil) {
                    cell.textLabel?.text = manga.attributes.titles.zh_cn
                }
                else if (manga.attributes.titles.ko_kr != nil) {
                    cell.textLabel?.text = manga.attributes.titles.ko_kr
                }
                else if (manga.attributes.titles.th_th != nil) {
                    cell.textLabel?.text = manga.attributes.titles.th_th
                }
                else {
                    cell.textLabel?.text = manga.attributes.titles.en
                }
            }
        }
        else if (indexPath.section == 2) {
            if (manga.authors?.count ?? 0 > indexPath.row) {
                cell.textLabel?.text = manga.authors?[indexPath.row]
            }
            else {
                cell.textLabel?.text = "Unknown"
            }
        }
        else if (indexPath.section == 3) {
            if (manga.genres?.count ?? 0 > indexPath.row) {
                cell.textLabel?.text = manga.genres?[indexPath.row]
            }
            else {
                cell.textLabel?.text = "Unknown"
            }
        }
        else if (indexPath.section == 4) {
            cell.textLabel?.text = manga.attributes.status.capitalized
        }
        else if (indexPath.section == 5) {
            if (manga.attributes.averageRating == nil) {
                cell.textLabel?.text = "Unknown"
            }
            else {
                cell.textLabel?.text = manga.attributes.averageRating
            }
        }
        else {
            cell.textLabel?.text = manga.attributes.description ?? "No description available"
        }
        return cell
    }
    
    func tableView(_ mangaDetailTableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
