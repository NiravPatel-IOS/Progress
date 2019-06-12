//
//  ViewController.swift
//  Progress
//
//  Created by NiravPatel on 12/06/19.
//  Copyright © 2019 NiravPatel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// CircularProgressBar
    @IBOutlet weak var progressBar: CircularProgressBar!
    
    /// Overall progress
    var progress : Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        perform(#selector(startUpload), with: nil, afterDelay: 1.0)
    }
    
    //MARK: - Start uploading
    @objc func startUpload() {
        progressBar.labelSize = 30
        progressBar.safePercent = 100
        progressBar.setProgress(to: progress, withAnimation: true)
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        //timer.fire()
        RunLoop.main.add(timer, forMode: .common)
    }
    
    @objc func updateProgress() {
        
        progressBar.setProgress(to: progress, withAnimation: true)
        progress = progress + 0.06
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
