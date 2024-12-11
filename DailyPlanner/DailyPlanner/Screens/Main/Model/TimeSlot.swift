import Foundation

enum TimeSlot: String {

	case hour00 = "00:00 - 01:00"
	case hour01 = "01:00 - 02:00"
	// and so on
}

/*
 enum TimeSlot: Int, CaseIterable {
	 case hour0 = 0
	 case hour1
	 case hour2
	 // ...
	 case hour23

	 var dateComponents: DateComponents {
		 return DateComponents(hour: self.rawValue)
	 }

	 var title: String {
		 let formatter = DateFormatter()
		 formatter.dateFormat = "HH:mm"
		 let startDate = Calendar.current.date(from: dateComponents)!
		 let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: startDate)!
		 return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
	 }
 }

 // example of how to use

 let section = TimeSlot(rawValue: indexPath.section)!
			header.titleLabel.text = section.title // Set the header title using the enum's title property
 */
