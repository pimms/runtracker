//
//  WeeklyHistoryView.swift
//  runtracker
//
//  Created by pimms on 06/08/2019.
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import SwiftUI

struct WeeklyHistoryView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<10) {
                    WeeklyDistanceProgressView(weeksAgo: $0)
                }
            }.padding()
        }
    }
}

#if DEBUG
struct WeeklyHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        Text("TODO!")
    }
}
#endif
