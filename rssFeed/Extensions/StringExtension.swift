import Foundation

extension String {
    // Форматирование строки даты в необходимый формат для отображения
    var formattedDate: String {
        guard let date = DateFormatter.dateFormatFromXML.date(from: self) else { return "" }
        return DateFormatter.dateFormatForView.string(from: date)
    }
}
