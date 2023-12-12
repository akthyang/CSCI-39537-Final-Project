//
//  LoadingViewController.swift
//  Books2Love
//
//  Created by Alicia Yang on 12/3/23.
//  Creates a loading screen when data is being rendered

import UIKit

class LoadingViewController: UIViewController {
    
    var loadingActivityIndicator: UIActivityIndicatorView = {
        // UIActivityIndicatorView Configuration
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .gray
                
        indicator.startAnimating()
                
        // centers indicators and makes is responsive
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
                
        return indicator
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Loading...we're stuck in traffic"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
            
        loadingActivityIndicator.center = view.center
        view.addSubview(loadingActivityIndicator)
        view.addSubview(label)
        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 0.95)
        
        label.frame = CGRect(x: 80,
                             y: Int(loadingActivityIndicator.frame.minY) + 20,
                             width: Int(view.frame.width),
                             height: 30)
        // causes the text to slide off the screen
        UIView.animate(withDuration: 3, delay: 0,
          options: [.repeat, .curveEaseIn],
          animations: {
            self.label.frame = CGRect(x: -300,
                                      y: Int(self.loadingActivityIndicator.frame.minY) + 20,
                                      width: Int(self.view.frame.width),
                                      height: 30)
          },
          completion: nil
        )

    }
    
}
