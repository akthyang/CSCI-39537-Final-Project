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
        title = "Book of the Day"
        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 0.95)
        
        // creates a loading page until table has finished loading
        let loading = LoadingViewController()
        loading.label.text = "Running to get your novel..."
        self.navigationController?.pushViewController(loading, animated: false)
        // removes back button on top
        self.navigationController?.isNavigationBarHidden = true
        
        DispatchQueue.main.async {
            Task {
                do {
                    // gets the recommended book
                    self.recommend()
                    let book = try await BooksAPI.shared.recommendBook(genre: self.recommendationGenre)
                    
                    // add BookDetailViewController to this ViewController to display recommendation
                    let BookDetailsViewController = BookDetailsViewController(book: book)
                    self.addChild(BookDetailsViewController)
                    BookDetailsViewController.view.frame =  self.view.bounds
                    BookDetailsViewController.heading = self.heading
                    self.view.addSubview(BookDetailsViewController.view)
                    BookDetailsViewController.didMove(toParent: self)
                    
                    // removes loading page once table has loaded
                    self.navigationController?.popViewController(animated: false)
                    self.navigationController?.isNavigationBarHidden = false
                }
                catch {
                    print(error)
                }
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
                heading = 
                "Let's read a \(recommendationGenre), you'll be too immersed to remember your upset"
            }
        }
        else {
            recommendationGenre = genreHappy[genrePicker]
            heading = "How about a mood changer? Like reading a \(recommendationGenre)!"
        }
    }

}
