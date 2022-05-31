// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Correct
  internal static let correct = L10n.tr("Localizable", "correct")
  /// Correct attempts: %d
  internal static func correctAttempts(_ p1: Int) -> String {
    return L10n.tr("Localizable", "correctAttempts", p1)
  }
  /// Game Over
  internal static let gameOver = L10n.tr("Localizable", "gameOver")
  /// Incorrect attempts: %d
  internal static func incorrectAttempts(_ p1: Int) -> String {
    return L10n.tr("Localizable", "incorrectAttempts", p1)
  }
  /// Cannot parse data
  internal static let parsingError = L10n.tr("Localizable", "parsingError")
  /// The app will close now
  internal static let theAppWillCloseTheApp = L10n.tr("Localizable", "theAppWillCloseTheApp")
  /// Wrong
  internal static let wrong = L10n.tr("Localizable", "wrong")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
