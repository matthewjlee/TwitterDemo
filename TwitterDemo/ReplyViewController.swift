//
//  ReplyViewController.swift
//  TwitterDemo
//
//  Created by Richard Du on 2/9/17.
//  Copyright © 2017 Richard Du. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {
    
    var remainingCharCount: Int = 140
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var replyTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        charCountLabel.text = "\(remainingCharCount)"
        replyTextView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: AnyObject) {
        /*UIViewController *sourceViewController = self.sourceViewController;
        [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        */
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }

    func textViewDidChange(_ textView: UITextView) {
        remainingCharCount = 140 - (replyTextView.text?.characters.count)!
        charCountLabel.text = "\(remainingCharCount)"
        if(remainingCharCount < 0) {
            charCountLabel.textColor = UIColor.red
        } else {
            charCountLabel.textColor = UIColor.lightGray
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
