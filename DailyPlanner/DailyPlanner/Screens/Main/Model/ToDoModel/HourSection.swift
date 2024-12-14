import Foundation

enum HourSection: Int, CaseIterable, Hashable {
	case hour0 = 0
	case hour1
	case hour2
	case hour3
	case hour4
	case hour5
	case hour6
	case hour7
	case hour8
	case hour9
	case hour10
	case hour11
	case hour12
	case hour13
	case hour14
	case hour15
	case hour16
	case hour17
	case hour18
	case hour19
	case hour20
	case hour21
	case hour22
	case hour23

	var title: String {
		return String(format: "%02d:00", self.rawValue)
	}
}
