//  ViewController.swift
//
//  Created by patrick piemonte on 11/26/14.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014-present patrick piemonte (http://patrickpiemonte.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class ViewController: UIViewController {

    // MARK: view lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let synchronisationPath = Bundle.main.path(forResource: "synchronisation", ofType: "json")
        
        if synchronisationPath != nil {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: synchronisationPath!), options: .mappedIfSafe)
                let synchronisation = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                let videoUrl = "http://d171aj4mo5rrkj.cloudfront.net/lectures/2224/video.mp4"
                
                let seboViewPlayerViewController = SeboVideoPlayerViewController()
                
                let alertController = UIAlertController(title: "Loading...", message: "Preparing video and synchronisation.", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                
                seboViewPlayerViewController.loadVideoWithSynchronisation(videoUrl: videoUrl, synchronisation: synchronisation as! NSArray, loadingFinished: {
                    alertController.dismiss(animated: true, completion: {
                        self.present(seboViewPlayerViewController, animated: true, completion: nil)
                    })
                })
            } catch let error {
                fatalError("Synchronisation json error: " + error.localizedDescription)
            }
        } else {
            fatalError("Synchronisation json file not found")
        }
    }

}
