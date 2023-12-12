//
//  ViewController.swift
//  Books2Love
//
//  Created by Alicia Yang on 11/20/23.
//  MARK: allows user to select a certain emotion for the day
//
//  Image Sources
//  Happy: https://www.pinterest.com/pin/739857045031359757/
//  Sad: https://www.freepik.com/premium-vector/sticker-bunny-that-has-sad-face_40101114.htm
//  Bored: https://www.redbubble.com/i/sticker/a-bored-white-cat-studying-anime-by-unepommedeterre/145507941.EJUG5
// Sleepy: https://www.freepik.com/free-vector/cute-cat-sleeping-cartoon-vector-icon-illustration-animal-nature-icon-concept-isolated-premium-flat_26445551.htm#query=sleepy%20cat%20animated&position=4&from_view=search&track=ais&uuid=289834cd-34b0-4394-8f12-c541b592fda3

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
        welcome.font = UIFont.preferredFont(forTextStyle: .title2)
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
        // changes view controller to book of day when clicked on
        button.addTarget(self, action: #selector(recommend), for: UIControl.Event.touchUpInside)
        return button
    }
    
    // changes the root view controller when button is pressed
    @objc func recommend(sender: UIButton!) {
        // used to determine what genre of book to recommend
        UserDefaults.standard.setValue(sender.titleLabel?.text, forKey: "TodaysFeeling")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let TabBarController = storyboard.instantiateViewController(identifier: "TabBarController") as! UITabBarController
        // changes the root view controller to Book of Day Page
        TabBarController.selectedIndex = 1
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(TabBarController)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
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


