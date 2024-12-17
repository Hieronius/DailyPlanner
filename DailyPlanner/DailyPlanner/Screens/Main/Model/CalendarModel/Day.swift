import Foundation

struct Day {
  let date: Date
  let number: String
  var isSelected: Bool

  /// tracks is the current date on the visiable month or not
  let isWithinDisplayedMonth: Bool
}
