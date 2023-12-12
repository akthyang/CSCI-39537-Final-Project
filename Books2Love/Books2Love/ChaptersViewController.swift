//
//  ChaptersViewController.swift
//  Books2Love
//
//  Created by Alicia Yang on 12/11/23.
//  MARK: displays the chapter for the novel

import UIKit

class ChaptersViewController: UIViewController {

    private var chapter: Chapter
    private var novel: Novels

    lazy var chapterTableView: UITableView = {
        let chapterTableView = UITableView(frame: .zero, style: .grouped)
        chapterTableView.register(UITableViewCell.self, forCellReuseIdentifier: "book")
        chapterTableView.dataSource = self
        chapterTableView.delegate = self
        return chapterTableView
    }()
    
    init(chapter: Chapter, novel: Novels) {
        self.chapter = chapter
        self.novel = novel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(chapterTableView)
        chapterTableView.frame = view.bounds
        
        DispatchQueue.main.async {
            Task {
                do {
                    // creates a loading page until table has finished loading
                    let loading = LoadingViewController()
                    loading.label.text = "Please wait. Getting Chapter..."
                    self.navigationController?.pushViewController(loading, animated: false)
                    // removes back button on top
                    self.navigationController?.navigationBar.isHidden = true

                    let chapter = try await LightNovelAPI.shared.getChapter(chapter: self.chapter, novel: self.novel)
                    self.chapter = chapter
                    
                    // removes loading page once table has loaded
                    self.navigationController?.popViewController(animated: false)
                    self.navigationController?.navigationBar.isHidden = false
                    
                    self.chapterTableView.reloadData()
                }
                catch {
                    print(error)
                }
            }
        }
    }
    

}

// MARK: TableView Delegate and Data Source

extension ChaptersViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: code for each section
    
    func numberOfSections(in mangaDetailTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ chapterTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // MARK: code for each cell and row
    
    func tableView(_ chapterTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //let cell = bookDetailTableView.dequeueReusableCell(withIdentifier: "book", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "book")
        // makes sure this cells can no longer be clicked
        cell.selectionStyle = .none
        // makes sure text doesn't overflow if not enough lines
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        if (indexPath.row == 0) {
            cell.textLabel?.text = chapter.title
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        }
        else if (indexPath.row == 1) {
            chapter.content = chapter.content?.replacingOccurrences(of: "<br>", with: "\n")
            chapter.content = chapter.content?.replacingOccurrences(of: "\t", with: "")
            cell.textLabel?.text = chapter.content
        }
        return cell
    }
    
    func tableView(_ chapterTableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
