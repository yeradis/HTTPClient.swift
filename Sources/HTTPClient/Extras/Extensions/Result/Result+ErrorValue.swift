extension Result {

  public typealias Value = Success
  public typealias Error = Failure
}

public protocol ResultProtocol {

  associatedtype Value
  associatedtype Error: Swift.Error

  init(value: Value)
  init(error: Error)

  var result: Result<Value, Error> { get }
}

extension Result: ResultProtocol {

  public init(value: Value) {
    self = .success(value)
  }

  public init(error: Error) {
    self = .failure(error)
  }

  public var result: Result<Value, Error> {
    self
  }
}

extension Result {

  public var value: Value? {
    switch self {
    case let .success(value): return value
    case .failure: return nil
    }
  }

  public var error: Error? {
    switch self {
    case .success: return nil
    case let .failure(error): return error
    }
  }
}