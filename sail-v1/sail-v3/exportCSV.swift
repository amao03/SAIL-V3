////
////  exportCSV.swift
////  sail-v3
////
////  Created by Alice Mao on 2/7/25.
////
//
//import UIKit
//import CoreData
//
//class CSVExporter {
//    static func exportRowingTestsToCSV() -> URL? {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<RowingTest> = RowingTest.fetchRequest()
//        
//        do {
//            let tests = try context.fetch(fetchRequest)
//            var csvString = "Test Name,Start Time,End Time,Subject ID,Interval Timestamp,Interval Value,Interval Target\n"
//
//            for test in tests {
//                let testName = test.testname ?? "Unknown"
//                let startTime = test.starttime?.description ?? "Unknown"
//                let endTime = test.endtime?.description ?? "Unknown"
//                let subjectID = test.subjectID ?? "Unknown"
//                
//                if let intervals = test.intervals as? Set<Interval> {
//                    for interval in intervals {
//                        let timestamp = interval.timestamp?.description ?? "Unknown"
//                        let value = interval.value?.description ?? "Unknown"
//                        let target = interval.target?.description ?? "Unknown"
//                        csvString.append("\(testName),\(startTime),\(endTime),\(subjectID),\(timestamp),\(value),\(target)\n")
//                    }
//                } else {
//                    csvString.append("\(testName),\(startTime),\(endTime),\(subjectID),,,\n") // No intervals
//                }
//            }
//
//            return saveCSV(csvString: csvString)
//        } catch {
//            print("Error fetching RowingTest entities: \(error)")
//            return nil
//        }
//    }
//
//    private static func saveCSV(csvString: String) -> URL? {
//        let fileName = "RowingTests.csv"
//        let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
//
//        do {
//            try csvString.write(to: filePath, atomically: true, encoding: .utf8)
//            return filePath
//        } catch {
//            print("Error saving CSV file: \(error)")
//            return nil
//        }
//    }
//
//    static func shareCSV(from viewController: UIViewController) {
//        if let fileURL = exportRowingTestsToCSV() {
//            let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
//            viewController.present(activityVC, animated: true, completion: nil)
//        }
//    }
//}
