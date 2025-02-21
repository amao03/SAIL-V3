//
//  SavedTestsView.swift
//  v2
//
//  Created by Lucas Drummond on 2/26/24.
//

import SwiftUI
import Charts

struct SavedTestsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RowingTest.starttime, ascending: false)],
        animation: .default)
    private var rowingTests: FetchedResults<RowingTest>

    var body: some View {
            NavigationStack {
                List {
                    Section(header: Text("Previous Tests")) {
                        ForEach(rowingTests) { rowingTest in
                            NavigationLink {
                                SavedTestDetailView(rowingTest: rowingTest)
                            } label: {
                                Text(formatTime(rowingTest.starttime))
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }.toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { rowingTests[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct SavedTestDetailView: View {
    var rowingTest: RowingTest
    var intervals: [Interval]?

    init(rowingTest: RowingTest) {
        self.rowingTest = rowingTest
//        self.intervals = rowingTest.intervals?.sortedArray(using: [timeSort]) as? [Interval]
        
//        debugPrint(self.intervals as Any)
    }

    var body: some View {
        let formattedStarttime = formatTime(rowingTest.starttime);
        let duration = getActiveTestDuration(rowingTest);

        Text("Test")
            .font(.largeTitle)
        List {
            Text("Start: \(formattedStarttime)")
            Text("Duration: \(duration)")
            Text("Subject Id: \(rowingTest.subjectId ?? "")")
            Text("Test Name: \(rowingTest.testName ?? "")")
        }

        if(intervals != nil) {
            Chart(intervals!) {
                LineMark(
                    x: .value("Time", $0.timestamp!),
                    y: .value("Power", $0.value)
                )
            }
            .padding(20)
        }
    }
}


