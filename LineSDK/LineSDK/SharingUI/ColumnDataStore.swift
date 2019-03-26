//
//  ColumnDataStore.swift
//
//  Copyright (c) 2016-present, LINE Corporation. All rights reserved.
//
//  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
//  copy and distribute this software in source code or binary form for use
//  in connection with the web services and APIs provided by LINE Corporation.
//
//  As with any software that integrates with the LINE Corporation platform, your use of this software
//  is subject to the LINE Developers Agreement [http://terms2.line.me/LINE_Developers_Agreement].
//  This copyright notice shall be included in all copies or substantial portions of the software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

extension Notification.Name {
    static let columnDataStoreDidAppendData = Notification.Name("com.linecorp.linesdk.columnDataStoreDidAppendData")
    static let columnDataStoreDidSelected = Notification.Name("com.linecorp.linesdk.columnDataStoreDidSelected")
    static let columnDataStoreDidUnselected = Notification.Name("com.linecorp.linesdk.columnDataStoreDidUnselected")
}

extension LineSDKNotificationKey {
    static let appendDataIndexRange = "appendDataIndexRange"
    static let selectingIndex = "selectingIndex"
}

class ColumnDataStore<T> {

    struct ColumnIndex: Equatable {
        let row: Int
        let column: Int
    }

    struct AppendingIndexRange {
        let startIndex: Int
        let endIndex: Int
        let column: Int
    }

    private var data: [[T]]
    private var selected: [ColumnIndex] = []

    private var columnCount: Int { return data.count }

    var maximumSelectedCount = 10

    init(columnCount: Int) {
        data = .init(repeating: [], count: columnCount)
    }

    func append(data appendingData: [T], to columnIndex: Int) {
        var column = data(atColumn: columnIndex)

        let startIndex = column.count

        column.append(contentsOf: appendingData)
        data[columnIndex] = column

        let endIndex = column.count
        let indexRange = AppendingIndexRange(startIndex: startIndex, endIndex: endIndex, column: columnIndex)

        // Make sure the notification is delivered on the main thread since it is often used to update UI.
        CallbackQueue.currentMainOrAsync.execute {
            NotificationCenter.default.post(
                name: .columnDataStoreDidAppendData,
                object: self,
                userInfo: [LineSDKNotificationKey.appendDataIndexRange: indexRange]
            )
        }
    }

    func data(atColumn columnIndex: Int) -> [T] {
        precondition(columnIndex < columnCount, "Input index `columnIndex` is out of range. Data range: 0..<\(data.count)")
        return data[columnIndex]
    }

    func data(atColumn columnIndex: Int, row rowIndex: Int) -> T {
        return data[columnIndex][rowIndex]
    }

    // Return `false` if the toggle failed due to `maximumSelectedCount` reached.
    func toggleSelect(atColumn columnIndex: Int, row rowIndex: Int) -> Bool {

        func notifySelectingChange(_ targetIndex: ColumnIndex) {
            NotificationCenter.default.post(
                name: .columnDataStoreDidUnselected,
                object: self,
                userInfo: [LineSDKNotificationKey.selectingIndex: targetIndex]
            )
        }

        let targetIndex = ColumnIndex(row: rowIndex, column: columnIndex)
        if let index = selected.firstIndex(of: targetIndex) {
            selected.remove(at: index)
        } else {
            guard selected.count < maximumSelectedCount else {
                return false
            }
            selected.append(targetIndex)
        }
        
        notifySelectingChange(targetIndex)
        return true
    }

}
