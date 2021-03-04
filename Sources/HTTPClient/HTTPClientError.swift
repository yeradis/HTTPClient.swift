import Foundation

public enum HTTPClientError: Error {
    case networkError
    case serverError
    case httpClientError(error: Error)
    case parsingError
    case unknown

    init(statusCode: Int) {
        switch statusCode {
        case 500...599:
            self = .serverError
        default:
            self = .unknown
        }
    }
}

extension HTTPClientError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .networkError:
            return "Network Error!"
        case .serverError:
            return "Server Error!"
        case .httpClientError(let error):
            return "HTTP Client Error \(error.localizedDescription)"
        case .parsingError:
            return "Parsing Error!"
        case .unknown:
            return "Unknown!"
        }
    }
}

extension HTTPClientError: CustomDebugStringConvertible {
    public var debugDescription: String {
        description
    }
}

extension HTTPClientError: Equatable {
}

public func ==(lhs: HTTPClientError, rhs: HTTPClientError) -> Bool {
    switch (lhs, rhs) {
    case (.networkError, .networkError):
        return true
    case (.serverError, .serverError):
        return true
    case (let .httpClientError(errorlhs), let .httpClientError(errorrhs)):
        return errorlhs._code == errorrhs._code && errorlhs._domain == errorrhs._domain
    case (.parsingError, .parsingError):
        return true
    case (.unknown, .unknown):
        return true
    default:
        return false
    }
}
