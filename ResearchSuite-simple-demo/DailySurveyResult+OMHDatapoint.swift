//
//  DailySurveyResult+OMHDatapoint.swift
//  ResearchSuite-simple-demo
//
//  Created by Christina Tsangouri on 8/10/17.
//  Copyright © 2017 Christina Tsangouri. All rights reserved.
//

import OMHClient

extension DailySurveyResult: OMHDataPointBuilder {
    
    open var creationDateTime: Date {
        return self.startDate ?? Date()
    }
    
    open var dataPointID: String {
        return self.uuid.uuidString
    }
    
    open var acquisitionModality: OMHAcquisitionProvenanceModality? {
        return .SelfReported
    }
    
    open var acquisitionSourceCreationDateTime: Date? {
        return self.startDate
    }
    
    open var acquisitionSourceName: String? {
        return Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
    }
    
    open var schema: OMHSchema {
        return OMHSchema(name: "study-daily-survey", version: "1.0", namespace: "cornell")
    }
    
    open var body: [String: Any] {
        var returnBody: [String: Any] = [:]
        
        returnBody["question_1"] = self.question_1
    
        return returnBody
        
    }
    
}
