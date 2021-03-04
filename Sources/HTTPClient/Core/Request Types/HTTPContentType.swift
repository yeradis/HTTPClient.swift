public struct HTTPContentType: Equatable {
  let value: String

  static let applicationJSON = HTTPContentType(value: "application/json")
  static let applicationFORM = HTTPContentType(value: "application/x-www-form-urlencoded")
}