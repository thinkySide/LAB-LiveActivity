//
//  LiveTimerView.swift
//  LiveTimer
//
//  Created by 김민준 on 12/30/24.
//

import SwiftUI
import Combine

struct LiveTimerView: View {
    
    @State private var timerCancellabe: AnyCancellable?
    
    @State private var selectedTime: Time = .min60
    @State private var isTracking = false
    
    @State private var startDate: Date = .now
    @State private var estimateSeconds: TimeInterval = 0
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
    }
    
    private var timerFormat: String {
        if isTracking {
            let endSeconds = endDate.timeIntervalSince1970
            let startSeconds = startDate.timeIntervalSince1970
            return (endSeconds - startSeconds - estimateSeconds).timerFormat
        } else {
            return "00:00:00"
        }
    }
    
    private func timerActionButtonTapped() {
        isTracking.toggle()
        if isTracking {
            startDate = .now
            endDate = .now + selectedTime.toSeconds
            timerCancellabe = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    estimateSeconds += 1
                }
        } else {
            timerCancellabe = nil
            estimateSeconds = 0
        }
    }
}

// MARK: - TimePicker

private struct TimePicker: View {
    
    @Binding var selectedTime: Time
    
    var body: some View {
        HStack(spacing: 24) {
            ForEach(Time.allCases) { time in
                TimePickerCell(
                    selectedTime: $selectedTime,
                    time: time
                )
            }
        }
    }
}

// MARK: - TimePickerCell

private struct TimePickerCell: View {
    
    @Binding var selectedTime: Time
    
    let time: Time
    
    private var isSelected: Bool {
        selectedTime == time
    }
    
    var body: some View {
        Button {
            selectedTime = time
        } label: {
            Text(time.timeFormat)
                .padding()
                .fontWeight(isSelected ? .bold : .medium)
                .foregroundStyle(isSelected ? .white : .blue)
                .background(isSelected ? .blue : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

// MARK: - Preview

#Preview {
    LiveTimerView()
}
