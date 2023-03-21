import Foundation

extension DateFormatter {
    // Форматы даты из XML и для отображения
    static let dateFormatFromXML: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return formatter
    }()

    static let dateFormatForView: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}
