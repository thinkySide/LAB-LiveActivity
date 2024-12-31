//
//  LiveTimerActivity.swift
//  LiveTimer
//
//  Created by 김민준 on 12/30/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

/// 속성 정의
struct LiveTimerActivityAttributes: ActivityAttributes {
    
    // 동적 프로퍼티
    public struct ContentState: Codable, Hashable {
        var startDate: Date
        var endDate: Date
    }
    
    // 정적 프로퍼티
}

/// 화면 정의
struct LiveTimerActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveTimerActivityAttributes.self) { context in
            LockScreen(state: context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    
                }
                DynamicIslandExpandedRegion(.trailing) {
                    
                }
                DynamicIslandExpandedRegion(.bottom) {
                    
                }
            } compactLeading: {
                
            } compactTrailing: {
                
            } minimal: {
                
            }
        }
    }
}

// MARK: - LockScreen

private struct LockScreen: View {
    
    let state: LiveTimerActivityAttributes.ContentState
    
    var body: some View {
        Text(
            timerInterval: state.startDate...state.endDate,
            countsDown: true,
            showsHours: true
        )
        .font(.system(size: 24, weight: .bold))
    }
}
