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
    let genre = ["adventure","fantasy", "comedy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Task {
            do {
                // gets the recommended book
                recommend()
                let book = try await BooksAPI.shared.recommendBook(genre: recommendationGenre)
                print(book)
                
                // add BookDetailViewController to this ViewController to display recommendation
                let BookDetailsViewController = BookDetailsViewController(book: book)
                addChild(BookDetailsViewController)
                BookDetailsViewController.view.frame =  view.bounds
                //BookDetailViewController.heading = heading
                view.addSubview(BookDetailsViewController.view)
                BookDetailsViewController.didMove(toParent: self)
            }
            catch {
                print(error)
            }
        }
    }
    
    func recommend() {
        // calls the api extension recommend
        if (feeling == "Bored") {
            recommendationGenre = genre[0]
            heading = "Let's read an \(recommendationGenre) to blow the boredom away!"
        }
        else if (feeling == "Sad") {
            recommendationGenre = genre[1]
            heading = "Let's read an \(recommendationGenre) to blow the boredom away!"
        }
        else {
            recommendationGenre = genre[2]
            heading = "Let's read an \(recommendationGenre) to blow the boredom away!"
        }
    }

}
