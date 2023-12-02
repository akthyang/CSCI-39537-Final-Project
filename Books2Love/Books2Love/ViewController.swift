//
//  ViewController.swift
//  Books2Love
//
//  Created by Alicia Yang on 12/2/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create the image buttons
        let happy = CustomButton(titleString: "Happy")
        let sad = CustomButton(titleString: "Sad")
        let bored = CustomButton(titleString: "Sleepy")
            
        // create their labels and the header
        let welcome = Label(title: "Welcome Back!")
        let feeling = Label(title: "How are you feeling today?")
        let hLabel = Label(title: "Happy")
        let sLabel = Label(title: "Sad")
        let bLabel = Label(title: "Meh")
            
        // setting CGRect will allow us to format w/o using constraint
        // not set up for rotating
        welcome.frame = CGRect(x: 103, y: 126, width: 194, height: 35)
        feeling.frame = CGRect(x: 41, y: 200, width: 319, height: 30)
        happy.frame = CGRect(x: 112, y: 270, width: 173, height: 126)
        hLabel.frame = CGRect(x: 171, y: 387, width: 50, height: 21)
        sLabel.frame = CGRect(x: 181, y: 531, width: 30, height: 21)
        sad.frame = CGRect(x: 108, y: 406, width: 177, height: 123)
        bLabel.frame = CGRect(x: 177, y: 667, width: 46, height: 21)
        bored.frame = CGRect(x: 99, y: 547, width: 203, height: 160)
            
        // add to view
        view.addSubview(welcome)
        view.addSubview(feeling)
        view.addSubview(happy)
        view.addSubview(hLabel)
        view.addSubview(sad)
        view.addSubview(sLabel)
        view.addSubview(bored)
        view.addSubview(bLabel)
    }
    
    // MARK: Button Customization and Action
    
    // structure to create image button
    func CustomButton(titleString: String) -> UIButton {
        let button = UIButton(type: .custom)
        // allows the button to show an image
        button.setBackgroundImage(UIImage(imageLiteralResourceName: titleString), for: .normal)
        button.contentMode = .scaleToFill
        // changes the title to the emotion of button
        button.setTitle(titleString, for: .highlighted)
        button.setTitleColor(.white, for: .highlighted)
        return button
    }

}


// MARK: Class to make creating labels easier
class Label: UILabel {
    
    required init(title: String) {
        // changes height and width
        super.init(frame: .zero)
        self.text = title
        self.textColor = .black
        self.textAlignment = .center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


