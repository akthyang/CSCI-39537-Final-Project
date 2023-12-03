//
//  BoDViewController.swift
//  Books2Love
//
//  Created by Alicia Yang on 12/1/23.
//

import UIKit

class BoDViewController: UIViewController {

    var recommendationGenre = ""
    var heading = ""
    
    let feeling = UserDefaults.standard.value(forKey: "TodaysFeeling") as! String
    let genrePicker = Int.random(in: 0..<2)
    let genreBored = ["action","thriller"]
    let genreSad = ["humor", "fantasy"]
    let genreHappy = ["romance", "mystery"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Task {
            do {
                // gets the recommended book
                recommend()
                let book = try await BooksAPI.shared.recommendBook(genre: recommendationGenre)
                
                // add BookDetailViewController to this ViewController to display recommendation
                let BookDetailsViewController = BookDetailsViewController(book: book)
                addChild(BookDetailsViewController)
                BookDetailsViewController.view.frame =  view.bounds
                BookDetailsViewController.heading = heading
                view.addSubview(BookDetailsViewController.view)
                BookDetailsViewController.didMove(toParent: self)
            }
            catch {
                print(error)
            }
        }
    }
    
    // MARK: helper funtion - changes the recommendationGenre and heading according to feeling
    func recommend() {
        if (feeling == "Sleepy") {
            recommendationGenre = genreBored[genrePicker]
            heading = "Let's read a \(recommendationGenre) to blow the boredom away!"
        }
        else if (feeling == "Sad") {
            recommendationGenre = genreSad[genrePicker]
            if (recommendationGenre == "humor") {
                heading = "A book full of \(recommendationGenre) will definitely make you laugh!"
            }
            else {
                heading = "Let's read a \(recommendationGenre), it'll definitely make you forget your sadness"
            }
        }
        else {
            recommendationGenre = genreHappy[genrePicker]
            heading = "How about a mood changer? Like reading a \(recommendationGenre)!"
        }
    }

}
