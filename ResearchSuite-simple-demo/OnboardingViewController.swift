//
//  OnboardingViewController.swift
//  ResearchSuite-simple-demo
//
//  Created by Christina Tsangouri on 8/10/17.
//  Copyright © 2017 Christina Tsangouri. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss
import ResearchSuiteAppFramework

class OnboardingViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var sampleSurvey: RSAFScheduleItem!
    var store: RSStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.store = RSStore()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        
        guard let signInActivity = AppDelegate.loadActivity(filename: "signIn"),
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let steps = appDelegate.taskBuilder.steps(forElement: signInActivity as JsonElement) else {
                return
        }
        
        let task = ORKOrderedTask(identifier: "signIn", steps: steps)
        
        let taskFinishedHandler: ((ORKTaskViewController, ORKTaskViewControllerFinishReason, Error?) -> ()) = { [weak self] (taskViewController, reason, error) in
            
            // When completed signing in, load sample onboarding survey
            self?.dismiss(animated: true, completion: {
                self!.sampleSurvey = AppDelegate.loadScheduleItem(filename: "sampleOnboardingSurvey")
                self?.launchActivity(forItem: (self?.sampleSurvey)!)
                
            })
            
        }
        
        let tvc = RSAFTaskViewController(
            activityUUID: UUID(),
            task: task,
            taskFinishedHandler: taskFinishedHandler
        )
        
        self.present(tvc, animated: true, completion: nil)

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
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc = storyboard.instantiateInitialViewController()
                appDelegate.transition(toRootViewController: vc!, animated: true)
            })
            
        }
        
        let tvc = RSAFTaskViewController(
            activityUUID: UUID(),
            task: task,
            taskFinishedHandler: taskFinishedHandler
        )
        
        self.present(tvc, animated: true, completion: nil)
    }
    

    
    




}
