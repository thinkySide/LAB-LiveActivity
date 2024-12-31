//
//  TimeInterval++.swift
//  LiveTimer
//
//  Created by 김민준 on 12/30/24.
//

import Foundation

extension TimeInterval {
    
    /// 타이머 포맷 00:00:00 문자열을 반환합니다.
    var timerFormat: String {
        let hours = abs(Int(self) / 3600)
        let minutes = abs((Int(self) % 3600) / 60)
        let seconds = abs(Int(self) % 60)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
