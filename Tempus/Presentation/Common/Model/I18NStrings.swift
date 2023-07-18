//
//  I18NStrings.swift
//  Tempus
//
//  Created by 이정민 on 2023/07/18.
//

import Foundation

enum I18NStrings {
    enum Alert {
        static let alertTitle = "alertTitle".localized
        static let alertFailTitle = "alertFailTitle".localized
        static let successCreateTitle = "successCreateTitle".localized
        static let storeAlertTitle = "storeAlertTitle".localized
        
        static let storeAlertMessage = "storeAlertMessage".localized
        static let timerStartNowMessage = "timerStartNowMessage".localized
        static let modeEmptyMessage = "modeEmptyMessage".localized
        static let dataEmptyCheckMessage = "dataEmptyCheckMessage".localized
        static let createFailMessage = "createFailMessage".localized
        static let repeatCountExceeded = "repeatCountExceeded".localized
        
        static let confirmAction = "confirmAction".localized
        static let deleteAction = "deleteAction".localized
        static let YesAction = "YesAction".localized
        static let NoAction = "NoAction".localized
    }
    
    enum NavigationItem {
        static let blockListTitle = "blockListTitle".localized
        static let dailyListTitle = "dailyListTitle".localized
        
        static let create = "create".localized
        static let edit = "edit".localized
        static let next = "next".localized
        static let start = "start".localized
    }
    
    enum View {
        static let timeInterval = "timeInterval".localized
        static let titlePlaceholder = "titlePlaceholder".localized
        static let select = "select".localized
        static let startButtonTitle = "startButtonTitle".localized
        
        static let focusTime = "focusTime".localized
        static let breakTime = "breakTime".localized
        static let startTime = "startTime".localized
        static let repeatCount = "repeatCount".localized
        
        static let waitingTimeComment = "waitingTimeComment".localized
        
    }
    
    enum DataManageError {
        static let createFailure = "createFailure".localized
        static let fetchFailure = "fetchFailure".localized
        static let updateFailure = "updateFailure".localized
        static let deleteFailure = "deleteFailure".localized
    }
}
