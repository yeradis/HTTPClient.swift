import Foundation

final class ConsoleLogable: Logable {

	static func info(_ message: @autoclosure () -> Any, _ file: String, _ function: String, line: Int, context: Any?) {
		msg(.info, message(),file,function,line: line, context: context)
	}

	static func debug(_ message: @autoclosure () -> Any, _ file: String, _ function: String, line: Int, context: Any?) {
		msg(.debug, message(),file,function,line: line, context: context)
	}

	static func error(_ message: @autoclosure () -> Any, _ file: String, _ function: String, line: Int, context: Any?) {
		msg(.error, message(),file,function,line: line, context: context)
	}

	private static func msg(_ logType:LogType, _ message: @autoclosure () -> Any, _ file: String, _ function: String, line: Int, context: Any?) {

		var filename = (file as NSString).lastPathComponent
		filename = filename.components(separatedBy: ".")[0]

		let currentDate = Date()
		let df = DateFormatter()
		df.dateFormat = "HH:mm:ss.SSS"
		let dateString = df.string(from: currentDate)

		print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
		print("\(logType.capitalLetter) \(logType.symbol) time: \(dateString)")
		print("\(filename).\(function) line: \(line)")
		print("\(message())")
		print("-----------------------------------------------------------")
	}
}