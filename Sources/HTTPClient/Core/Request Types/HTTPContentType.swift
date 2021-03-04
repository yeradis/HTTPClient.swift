public struct HTTPContentType: Equatable {
  let value: String

  public static let applicationJSON = HTTPContentType(value: "application/json")
  public static let applicationFORM = HTTPContentType(value: "application/x-www-form-urlencoded")
}