//
//  ReplyViewController.swift
//  TwitterDemo
//
//  Created by Richard Du on 2/9/17.
//  Copyright © 2017 Richard Du. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {
    
    var replyTweetID: Int?
    var replyUsername: String?
    @IBOutlet weak var tweetButton: UIButton!
    var remainingCharCount: Int = 140
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var replyTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        charCountLabel.text = "\(remainingCharCount)"
        replyTextView.delegate = self
        replyTextView.becomeFirstResponder()
        replyTextView.text = "@\(replyUsername!) "
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func onTweet(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.updateStatus(success: { () in
            print("reply success")
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            
        }, failure: { (error:Error) in
            print(error.localizedDescription)
        }, status: replyTextView.text, replyTweetID: replyTweetID)
    }
    func textViewDidChange(_ textView: UITextView) {
        remainingCharCount = 140 - (replyTextView.text?.characters.count)!
        charCountLabel.text = "\(remainingCharCount)"
        if(remainingCharCount < 0) {
            charCountLabel.textColor = UIColor.red
            tweetButton.isEnabled = false
        } else {
            charCountLabel.textColor = UIColor.lightGray
            tweetButton.isEnabled = true
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("done editing")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
