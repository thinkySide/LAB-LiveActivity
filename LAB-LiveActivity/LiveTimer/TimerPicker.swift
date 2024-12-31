//
//  TimerPicker.swift
//  LiveTimer
//
//  Created by 김민준 on 12/30/24.
//

import SwiftUI

// MARK: - TimePicker

struct TimePicker: View {
    
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
