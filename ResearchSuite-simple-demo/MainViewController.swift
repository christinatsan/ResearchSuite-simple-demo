//
//  ViewController.swift
//  ResearchSuite-simple-demo
//
//  Created by Christina Tsangouri on 8/9/17.
//  Copyright © 2017 Christina Tsangouri. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss
import ResearchSuiteAppFramework

class MainViewController: UIViewController {
    
    var store: RSStore!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var sampleDailySurvey: RSAFScheduleItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.store = RSStore()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Launch sample daily survey
        
        // Daily survey should be launched once, when opening app
        let shouldDoDaily = self.store.valueInState(forKey: "shouldDoDaily") as! Bool
        
        if shouldDoDaily {
            self.store.setValueInState(value: false as NSSecureCoding, forKey: "shouldDoDaily")
            self.sampleDailySurvey = AppDelegate.loadScheduleItem(filename: "sampleDailySurvey")
            self.launchActivity(forItem: (self.sampleDailySurvey)!)
            
        }
        
        
    }
    
    func launchActivity(forItem item: RSAFScheduleItem) {
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let steps = appDelegate.taskBuilder.steps(forElement: item.activity as JsonElement) else {
                return
        }
        
        let task = ORKOrderedTask(identifier: item.identifier, steps: steps)
        
        let taskFinishedHandler: ((ORKTaskViewController, ORKTaskViewControllerFinishReason, Error?) -> ()) = { [weak self] (taskViewController, reason, error) in
            
            //when finised, if task was successful (e.g., wasn't canceled)
            //process results
            if reason == ORKTaskViewControllerFinishReason.completed {
                let taskResult = taskViewController.result
                appDelegate.resultsProcessor.processResult(taskResult: taskResult, resultTransforms: item.resultTransforms)
                
            }
            
            self?.dismiss(animated: true,completion: {
            /* 1.If you want to launch another survey you can do so from here:
                  self.nextSurvey = AppDelegate.loadScheduleItem(filename: "nextSurvey")
                  self.launchActivity(forItem: (self.nextSurvey)!)
               2. Leave blank here to dismiss survey and stay in home page
               3. Otherwise navigate to next view controller from here */

                
            })
            
        }
        
        let tvc = RSAFTaskViewController(
            activityUUID: UUID(),
            task: task,
            taskFinishedHandler: taskFinishedHandler
        )
        
        self.present(tvc, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

