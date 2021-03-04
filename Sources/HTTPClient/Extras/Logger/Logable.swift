import Foundation

protocol Logable {
	static func info(_ message: @autoclosure () -> Any, _ file: String, _ function: String, line: Int, context: Any?)
	static func debug(_ message: @autoclosure () -> Any, _ file: String, _ function: String, line: Int, context: Any?)
	static func error(_ message: @autoclosure () -> Any, _ file: String, _ function: String, line: Int, context: Any?)
}


enum LogType{
	case info
	case debug
	case error

	var symbol : String {
		switch self {
		case .info : return "ℹ️"
		case .debug : return "🔍"
		case .error : return "⛔"
		}
	}

	var capitalLetter : String{
		"\(self)".uppercased()
	}
}