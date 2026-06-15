//
//  View+LongPress.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 16/06/2026.
//

import SwiftUI

extension View {
    func pauseOnLongPress(
        stopTimer: @escaping () -> Void,
        startTimer: @escaping () -> Void
    ) -> some View {
        self.onLongPressGesture(
            minimumDuration: 0.2,
            pressing: { isPressing in
                if isPressing {
                    stopTimer()
                } else {
                    startTimer()
                }
            }, perform: {}
        )
    }
}
