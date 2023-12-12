//
//  NovelViewController.swift
//  Books2Love
//
//  Created by Alicia Yang on 12/11/23.
//  MARK: displays the light novel info

import UIKit

class NovelDetailsViewController: UIViewController {

    private var novel: Novels
    
    // only applicable on Book of Day Page
    var heading: String = ""

    lazy var novelDetailTableView: UITableView = {
        let novelDetailTableView = UITableView(frame: .zero, style: .grouped)
        novelDetailTableView.register(UITableViewCell.self, forCellReuseIdentifier: "novel")
        novelDetailTableView.dataSource = self
        novelDetailTableView.delegate = self
        return novelDetailTableView
    }()
    
    init(novel: Novels) {
        self.novel = novel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(novelDetailTableView)
        novelDetailTableView.frame = view.bounds
    }
    

}

// MARK: TableView Delegate and Data Source

extension NovelDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: header of each section
    
    func tableView(_ novelDetailTableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // only applies for BoD page
        if (section == 0 && heading != "") {
            return heading
        }
        else if (section == 1) {
            return "Author"
        }
        else if (section == 2) {
            return "Genre"
        }
        else if (section == 3) {
            return "Status"
        }
        else if (section == 4) {
            return "Description"
        }
        else if (section == 5) {
            return "Chapters"
        }
        return nil
    }
    
    // MARK: code for each section
    
    func numberOfSections(in novelDetailTableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ novelDetailTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 2
        }
        else if (section == 5) {
            return novel.novelInfo?.novel.chapters?.count ?? 1
        }
        return 1
    }
    
    // MARK: code for each cell and row
    
    func tableView(_ novelDetailTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //let cell = bookDetailTableView.dequeueReusableCell(withIdentifier: "book", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "novel")
        // makes sure this cells can no longer be clicked
        cell.selectionStyle = .none
        // makes sure text doesn't overflow if not enough lines
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.textColor = .black
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                novel.title = novel.title.capitalized
                cell.textLabel?.text = novel.title
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
                cell.selectionStyle = .none
            }
            else {
                let coverCell = CoverTableViewCell(reuseIdentifier: "coverCell")
                // makes sure cover image link exists
                let safeURL = novel.novelInfo?.novel.cover ?? ""
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
            cell.textLabel?.text = novel.novelInfo?.novel.author.replacingOccurrences(of: "：", with: "")
        }
        else if (indexPath.section == 2) {
            cell.textLabel?.text = novel.novelInfo?.novel.genre
        }
        else if (indexPath.section == 3) {
            cell.textLabel?.text = novel.novelInfo?.novel.status.replacingOccurrences(of: "：", with: "")
        }
        else if (indexPath.section == 4) {
            cell.textLabel?.text = novel.novelInfo?.novel.summary
        }
        else {
            if (novel.novelInfo?.novel.chapters?.count ?? 0 > 0) {
                cell.textLabel?.text = novel.novelInfo?.novel.chapters?[indexPath.row].title
                // makes sure this chapter cells can be selected
                cell.selectionStyle = .gray
            }
            else {
                cell.textLabel?.text = "No chapters listed"
            }
        }
        return cell
    }
    
    func tableView(_ novelDetailTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 5) {
            let chapter = novel.novelInfo?.novel.chapters?[indexPath.row]
            let chaptersViewCountroller = ChaptersViewController(chapter: chapter!, novel: novel)
            navigationController?.pushViewController(chaptersViewCountroller, animated: true)
        }
    }
    
    func tableView(_ novelDetailTableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
