//
//  DailySurveyResult.swift
//  ResearchSuite-simple-demo
//
//  Created by Christina Tsangouri on 8/10/17.
//  Copyright © 2017 Christina Tsangouri. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteResultsProcessor
import Gloss
import OMHClient

open class DailySurveyResult: RSRPIntermediateResult, RSRPFrontEndTransformer {
    
    private static let supportedTypes = [
        "DailySurvey"
    ]
    
    public static func supportsType(type: String) -> Bool {
        return self.supportedTypes.contains(type)
    }
    
    
    public static func transform(taskIdentifier: String, taskRunUUID: UUID, parameters: [String : AnyObject]) -> RSRPIntermediateResult? {
        
        let question_1: [String]? = {
            guard let stepResult = parameters["question_1"],
                let result = stepResult.firstResult as? ORKChoiceQuestionResult,
                let choices = result.choiceAnswers as? [String] else {
                    return nil
            }
            return choices
        }()
        
        let daily = DailySurveyResult(
            uuid: UUID(),
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID,
            question_1: question_1!)
        
        daily.startDate = parameters["sleep_1"]?.startDate ?? Date()
        daily.endDate = parameters["commute_5"]?.endDate ?? Date()
    
        return daily
        
    }
    
    public let question_1: [String]?
    
    public init(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        question_1: [String]
        ) {
        
        
        self.question_1 = question_1
        
        
        super.init(
            type: "DailyStatus",
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
    }
    
}
