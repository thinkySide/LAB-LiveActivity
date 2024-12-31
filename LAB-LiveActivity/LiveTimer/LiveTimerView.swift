//
//  LiveTimerView.swift
//  LiveTimer
//
//  Created by 김민준 on 12/30/24.
//

import SwiftUI
import Combine
import ActivityKit

struct LiveTimerView: View {
    
    @AppStorage("resignSeconds") var resignSeconds = UserDefaults.standard.integer(forKey: "resignSeconds")
    @AppStorage("durationSeconds") var durationSeconds = UserDefaults.standard.integer(forKey: "durationSeconds")
    @AppStorage("isFromBackground") var isFromBackground = UserDefaults.standard.bool(forKey: "isFromBackground")
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var activity: Activity<LiveTimerActivityAttributes>?
    @State private var timerCancellabe: AnyCancellable?
    @State private var selectedTime: Time = .min60
    @State private var isTracking = false
    @State private var startDate: Date = .now
    @State private var estimateSeconds = 0
    @State private var endDate: Date = .now
    
    var body: some View {
        VStack(spacing: 32) {
            TimePicker(selectedTime: $selectedTime)
            
            Text(timerFormat)
                .font(.system(size: 48, weight: .bold))
            
            Button {
                timerActionButtonTapped()
            } label: {
                Text(isTracking ? "타이머 종료" : "타이머 실행")
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(.regularMaterial)
                    .padding(.horizontal, 24)
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            guard oldValue != newValue, isTracking else { return }
            switch newValue {
            case .background:
                saveAppStorage()
                isFromBackground = true
                
            case .inactive:
                break
                
            case .active:
                if isFromBackground {
                    let duringSeconds = Int(Date.now.timeIntervalSince1970) - resignSeconds
                    estimateSeconds = duringSeconds + durationSeconds
                    resetAppStorage()
                    isFromBackground = false
                }
                
            @unknown default:
                break
            }
        }
    }
}

// MARK: - AppStorage

extension LiveTimerView {
    
    private func saveAppStorage() {
        resignSeconds = Int(Date.now.timeIntervalSince1970)
        durationSeconds = Int(estimateSeconds)
    }
    
    private func resetAppStorage() {
        resignSeconds = 0
        durationSeconds = 0
    }
}

// MARK: - Formatter

extension LiveTimerView {
    
    private var timerFormat: String {
        if isTracking {
            let endSeconds = endDate.timeIntervalSince1970
            let startSeconds = startDate.timeIntervalSince1970
            let timeSeconds = endSeconds - startSeconds - TimeInterval(estimateSeconds)
            if timeSeconds >= 0 {
                return timeSeconds.timerFormat
            } else {
                return "+\((timeSeconds - 1).timerFormat)"
            }
        } else {
            return "00:00:00"
        }
    }
}

// MARK: - Function

extension LiveTimerView {
    
    private func timerActionButtonTapped() {
        isTracking.toggle()
        if isTracking {
            startDate = .now
            endDate = .now + selectedTime.toSeconds
            startLiveActivity()
            timerCancellabe = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    estimateSeconds += 1
                }
        } else {
            timerCancellabe = nil
            estimateSeconds = 0
            stopLiveActivity()
            resetAppStorage()
        }
    }
}

// MARK: - Live Activity

extension LiveTimerView {
    
    /// 라이브 액티비티 시작하기
    private func startLiveActivity() {
        let attributes = LiveTimerActivityAttributes()
        let state = LiveTimerActivityAttributes.ContentState(
            startDate: startDate,
            endDate: endDate
        )
        let content = ActivityContent(state: state, staleDate: nil)
        
        do {
            activity = try Activity<LiveTimerActivityAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
        } catch {
            print("Live Activity 실행 실패: \(error)")
        }
    }
    
    /// 라이브 액티비티 종료하기
    private func stopLiveActivity() {
        Task {
            await activity?.end(nil, dismissalPolicy: .immediate)
        }
    }
}

// MARK: - Preview

#Preview {
    LiveTimerView()
}
