import Foundation

class LocalizationService: ObservableObject {
    static let shared = LocalizationService()
    static let changedLanguage = Notification.Name("changedLanguage")

    private init() {}

    var language: Language {
        get {
            guard let languageString = UserDefaults.standard.string(forKey: "language") else {
                return .english_us
            }
            return Language(rawValue: languageString) ?? .english_us
        }
        set {
            if newValue != language {
                UserDefaults.standard.setValue(newValue.rawValue, forKey: "language")
                NotificationCenter.default.post(name: LocalizationService.changedLanguage, object: nil)
            }
        }
    }

    func setLanguage(to language: Language) {
        self.language = language
    }

    var availableLanguages: [String] {
        return Bundle.main.localizations
    }

    var currentLocale: Locale {
        return Locale(identifier: language.rawValue)
    }
}
