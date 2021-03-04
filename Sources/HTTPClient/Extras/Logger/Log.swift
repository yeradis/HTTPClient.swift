import Foundation

final class Log {

	static var logClass = ConsoleLogable.self

	class func info(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
		logClass.info(message(), file, function, line: line, context: context)
	}

	class func debug(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
		logClass.debug(message(), file, function, line: line, context: context)
	}

	class func error(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
		logClass.error(message(), file, function, line: line, context: context)
	}

}