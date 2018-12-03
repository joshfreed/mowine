//  This file was automatically generated and should not be edited.

import AWSAppSync

public struct CreateUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, email: String, firstName: String? = nil, lastName: String? = nil) {
    graphQLMap = ["id": id, "email": email, "firstName": firstName, "lastName": lastName]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var email: String {
    get {
      return graphQLMap["email"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var firstName: String? {
    get {
      return graphQLMap["firstName"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: String? {
    get {
      return graphQLMap["lastName"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }
}

public struct UpdateUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, email: String? = nil, firstName: String? = nil, lastName: String? = nil) {
    graphQLMap = ["id": id, "email": email, "firstName": firstName, "lastName": lastName]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var email: String? {
    get {
      return graphQLMap["email"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var firstName: String? {
    get {
      return graphQLMap["firstName"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: String? {
    get {
      return graphQLMap["lastName"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }
}

public struct DeleteUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateFriendshipInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, friendId: GraphQLID, friendshipUserId: GraphQLID) {
    graphQLMap = ["id": id, "friendId": friendId, "friendshipUserId": friendshipUserId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var friendId: GraphQLID {
    get {
      return graphQLMap["friendId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "friendId")
    }
  }

  public var friendshipUserId: GraphQLID {
    get {
      return graphQLMap["friendshipUserId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "friendshipUserId")
    }
  }
}

public struct UpdateFriendshipInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, friendId: GraphQLID? = nil, friendshipUserId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "friendId": friendId, "friendshipUserId": friendshipUserId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var friendId: GraphQLID? {
    get {
      return graphQLMap["friendId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "friendId")
    }
  }

  public var friendshipUserId: GraphQLID? {
    get {
      return graphQLMap["friendshipUserId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "friendshipUserId")
    }
  }
}

public struct DeleteFriendshipInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateWineInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil, wineUserId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt, "wineUserId": wineUserId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: String {
    get {
      return graphQLMap["type"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var variety: String? {
    get {
      return graphQLMap["variety"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "variety")
    }
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var rating: Int {
    get {
      return graphQLMap["rating"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "rating")
    }
  }

  public var location: String? {
    get {
      return graphQLMap["location"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "location")
    }
  }

  public var notes: String? {
    get {
      return graphQLMap["notes"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notes")
    }
  }

  public var price: String? {
    get {
      return graphQLMap["price"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "price")
    }
  }

  public var pairings: [String] {
    get {
      return graphQLMap["pairings"] as! [String]
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "pairings")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var wineUserId: GraphQLID? {
    get {
      return graphQLMap["wineUserId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "wineUserId")
    }
  }
}

public struct UpdateWineInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, type: String? = nil, variety: String? = nil, name: String? = nil, rating: Int? = nil, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String]? = nil, createdAt: String? = nil, wineUserId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt, "wineUserId": wineUserId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: String? {
    get {
      return graphQLMap["type"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var variety: String? {
    get {
      return graphQLMap["variety"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "variety")
    }
  }

  public var name: String? {
    get {
      return graphQLMap["name"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var rating: Int? {
    get {
      return graphQLMap["rating"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "rating")
    }
  }

  public var location: String? {
    get {
      return graphQLMap["location"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "location")
    }
  }

  public var notes: String? {
    get {
      return graphQLMap["notes"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notes")
    }
  }

  public var price: String? {
    get {
      return graphQLMap["price"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "price")
    }
  }

  public var pairings: [String]? {
    get {
      return graphQLMap["pairings"] as! [String]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "pairings")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var wineUserId: GraphQLID? {
    get {
      return graphQLMap["wineUserId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "wineUserId")
    }
  }
}

public struct DeleteWineInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct ModelUserFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDFilterInput? = nil, email: ModelStringFilterInput? = nil, firstName: ModelStringFilterInput? = nil, lastName: ModelStringFilterInput? = nil, and: [ModelUserFilterInput?]? = nil, or: [ModelUserFilterInput?]? = nil, not: ModelUserFilterInput? = nil) {
    graphQLMap = ["id": id, "email": email, "firstName": firstName, "lastName": lastName, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDFilterInput? {
    get {
      return graphQLMap["id"] as! ModelIDFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var email: ModelStringFilterInput? {
    get {
      return graphQLMap["email"] as! ModelStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var firstName: ModelStringFilterInput? {
    get {
      return graphQLMap["firstName"] as! ModelStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: ModelStringFilterInput? {
    get {
      return graphQLMap["lastName"] as! ModelStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var and: [ModelUserFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelUserFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelUserFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelUserFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelUserFilterInput? {
    get {
      return graphQLMap["not"] as! ModelUserFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelIDFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }
}

public struct ModelStringFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }
}

public struct ModelWineFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDFilterInput? = nil, type: ModelStringFilterInput? = nil, variety: ModelStringFilterInput? = nil, name: ModelStringFilterInput? = nil, rating: ModelIntFilterInput? = nil, location: ModelStringFilterInput? = nil, notes: ModelStringFilterInput? = nil, price: ModelStringFilterInput? = nil, pairings: ModelStringFilterInput? = nil, createdAt: ModelStringFilterInput? = nil, and: [ModelWineFilterInput?]? = nil, or: [ModelWineFilterInput?]? = nil, not: ModelWineFilterInput? = nil) {
    graphQLMap = ["id": id, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDFilterInput? {
    get {
      return graphQLMap["id"] as! ModelIDFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: ModelStringFilterInput? {
    get {
      return graphQLMap["type"] as! ModelStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var variety: ModelStringFilterInput? {
    get {
      return graphQLMap["variety"] as! ModelStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "variety")
    }
  }

  public var name: ModelStringFilterInput? {
    get {
      return graphQLMap["name"] as! ModelStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var rating: ModelIntFilterInput? {
    get {
      return graphQLMap["rating"] as! ModelIntFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "rating")
    }
  }

  public var location: ModelStringFilterInput? {
    get {
      return graphQLMap["location"] as! ModelStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "location")
    }
  }

  public var notes: ModelStringFilterInput? {
    get {
      return graphQLMap["notes"] as! ModelStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notes")
    }
  }

  public var price: ModelStringFilterInput? {
    get {
      return graphQLMap["price"] as! ModelStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "price")
    }
  }

  public var pairings: ModelStringFilterInput? {
    get {
      return graphQLMap["pairings"] as! ModelStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "pairings")
    }
  }

  public var createdAt: ModelStringFilterInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var and: [ModelWineFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelWineFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelWineFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelWineFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelWineFilterInput? {
    get {
      return graphQLMap["not"] as! ModelWineFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelIntFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, contains: Int? = nil, notContains: Int? = nil, between: [Int?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: Int? {
    get {
      return graphQLMap["contains"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: Int? {
    get {
      return graphQLMap["notContains"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }
}

public final class CreateUserMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateUser($input: CreateUserInput!) {\n  createUser(input: $input) {\n    __typename\n    id\n    email\n    firstName\n    lastName\n    wines {\n      __typename\n      items {\n        __typename\n        id\n        type\n        variety\n        name\n        rating\n        location\n        notes\n        price\n        pairings\n        createdAt\n      }\n      nextToken\n    }\n    friends {\n      __typename\n      items {\n        __typename\n        id\n        friendId\n      }\n      nextToken\n    }\n  }\n}"

  public var input: CreateUserInput

  public init(input: CreateUserInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createUser", arguments: ["input": GraphQLVariable("input")], type: .object(CreateUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createUser: CreateUser? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createUser": createUser.flatMap { $0.snapshot }])
    }

    public var createUser: CreateUser? {
      get {
        return (snapshot["createUser"] as? Snapshot).flatMap { CreateUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createUser")
      }
    }

    public struct CreateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("email", type: .nonNull(.scalar(String.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("wines", type: .object(Wine.selections)),
        GraphQLField("friends", type: .object(Friend.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil, wines: Wine? = nil, friends: Friend? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName, "wines": wines.flatMap { $0.snapshot }, "friends": friends.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var email: String {
        get {
          return snapshot["email"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "email")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var wines: Wine? {
        get {
          return (snapshot["wines"] as? Snapshot).flatMap { Wine(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "wines")
        }
      }

      public var friends: Friend? {
        get {
          return (snapshot["friends"] as? Snapshot).flatMap { Friend(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "friends")
        }
      }

      public struct Wine: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelWineConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .list(.object(Item.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelWineConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?]? {
          get {
            return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Wine"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("variety", type: .scalar(String.self)),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
            GraphQLField("location", type: .scalar(String.self)),
            GraphQLField("notes", type: .scalar(String.self)),
            GraphQLField("price", type: .scalar(String.self)),
            GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            GraphQLField("createdAt", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
            self.init(snapshot: ["__typename": "Wine", "id": id, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var variety: String? {
            get {
              return snapshot["variety"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "variety")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var rating: Int {
            get {
              return snapshot["rating"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "rating")
            }
          }

          public var location: String? {
            get {
              return snapshot["location"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "location")
            }
          }

          public var notes: String? {
            get {
              return snapshot["notes"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "notes")
            }
          }

          public var price: String? {
            get {
              return snapshot["price"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "price")
            }
          }

          public var pairings: [String] {
            get {
              return snapshot["pairings"]! as! [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "pairings")
            }
          }

          public var createdAt: String? {
            get {
              return snapshot["createdAt"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }
        }
      }

      public struct Friend: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFriendshipConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .list(.object(Item.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFriendshipConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?]? {
          get {
            return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Friendship"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("friendId", type: .nonNull(.scalar(GraphQLID.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, friendId: GraphQLID) {
            self.init(snapshot: ["__typename": "Friendship", "id": id, "friendId": friendId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var friendId: GraphQLID {
            get {
              return snapshot["friendId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "friendId")
            }
          }
        }
      }
    }
  }
}

public final class UpdateUserMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateUser($input: UpdateUserInput!) {\n  updateUser(input: $input) {\n    __typename\n    id\n    email\n    firstName\n    lastName\n    wines {\n      __typename\n      items {\n        __typename\n        id\n        type\n        variety\n        name\n        rating\n        location\n        notes\n        price\n        pairings\n        createdAt\n      }\n      nextToken\n    }\n    friends {\n      __typename\n      items {\n        __typename\n        id\n        friendId\n      }\n      nextToken\n    }\n  }\n}"

  public var input: UpdateUserInput

  public init(input: UpdateUserInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateUser", arguments: ["input": GraphQLVariable("input")], type: .object(UpdateUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateUser: UpdateUser? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateUser": updateUser.flatMap { $0.snapshot }])
    }

    public var updateUser: UpdateUser? {
      get {
        return (snapshot["updateUser"] as? Snapshot).flatMap { UpdateUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateUser")
      }
    }

    public struct UpdateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("email", type: .nonNull(.scalar(String.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("wines", type: .object(Wine.selections)),
        GraphQLField("friends", type: .object(Friend.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil, wines: Wine? = nil, friends: Friend? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName, "wines": wines.flatMap { $0.snapshot }, "friends": friends.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var email: String {
        get {
          return snapshot["email"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "email")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var wines: Wine? {
        get {
          return (snapshot["wines"] as? Snapshot).flatMap { Wine(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "wines")
        }
      }

      public var friends: Friend? {
        get {
          return (snapshot["friends"] as? Snapshot).flatMap { Friend(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "friends")
        }
      }

      public struct Wine: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelWineConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .list(.object(Item.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelWineConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?]? {
          get {
            return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Wine"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("variety", type: .scalar(String.self)),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
            GraphQLField("location", type: .scalar(String.self)),
            GraphQLField("notes", type: .scalar(String.self)),
            GraphQLField("price", type: .scalar(String.self)),
            GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            GraphQLField("createdAt", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
            self.init(snapshot: ["__typename": "Wine", "id": id, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var variety: String? {
            get {
              return snapshot["variety"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "variety")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var rating: Int {
            get {
              return snapshot["rating"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "rating")
            }
          }

          public var location: String? {
            get {
              return snapshot["location"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "location")
            }
          }

          public var notes: String? {
            get {
              return snapshot["notes"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "notes")
            }
          }

          public var price: String? {
            get {
              return snapshot["price"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "price")
            }
          }

          public var pairings: [String] {
            get {
              return snapshot["pairings"]! as! [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "pairings")
            }
          }

          public var createdAt: String? {
            get {
              return snapshot["createdAt"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }
        }
      }

      public struct Friend: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFriendshipConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .list(.object(Item.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFriendshipConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?]? {
          get {
            return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Friendship"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("friendId", type: .nonNull(.scalar(GraphQLID.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, friendId: GraphQLID) {
            self.init(snapshot: ["__typename": "Friendship", "id": id, "friendId": friendId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var friendId: GraphQLID {
            get {
              return snapshot["friendId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "friendId")
            }
          }
        }
      }
    }
  }
}

public final class DeleteUserMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteUser($input: DeleteUserInput!) {\n  deleteUser(input: $input) {\n    __typename\n    id\n    email\n    firstName\n    lastName\n    wines {\n      __typename\n      items {\n        __typename\n        id\n        type\n        variety\n        name\n        rating\n        location\n        notes\n        price\n        pairings\n        createdAt\n      }\n      nextToken\n    }\n    friends {\n      __typename\n      items {\n        __typename\n        id\n        friendId\n      }\n      nextToken\n    }\n  }\n}"

  public var input: DeleteUserInput

  public init(input: DeleteUserInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteUser", arguments: ["input": GraphQLVariable("input")], type: .object(DeleteUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteUser: DeleteUser? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteUser": deleteUser.flatMap { $0.snapshot }])
    }

    public var deleteUser: DeleteUser? {
      get {
        return (snapshot["deleteUser"] as? Snapshot).flatMap { DeleteUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteUser")
      }
    }

    public struct DeleteUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("email", type: .nonNull(.scalar(String.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("wines", type: .object(Wine.selections)),
        GraphQLField("friends", type: .object(Friend.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil, wines: Wine? = nil, friends: Friend? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName, "wines": wines.flatMap { $0.snapshot }, "friends": friends.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var email: String {
        get {
          return snapshot["email"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "email")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var wines: Wine? {
        get {
          return (snapshot["wines"] as? Snapshot).flatMap { Wine(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "wines")
        }
      }

      public var friends: Friend? {
        get {
          return (snapshot["friends"] as? Snapshot).flatMap { Friend(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "friends")
        }
      }

      public struct Wine: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelWineConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .list(.object(Item.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelWineConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?]? {
          get {
            return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Wine"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("variety", type: .scalar(String.self)),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
            GraphQLField("location", type: .scalar(String.self)),
            GraphQLField("notes", type: .scalar(String.self)),
            GraphQLField("price", type: .scalar(String.self)),
            GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            GraphQLField("createdAt", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
            self.init(snapshot: ["__typename": "Wine", "id": id, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var variety: String? {
            get {
              return snapshot["variety"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "variety")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var rating: Int {
            get {
              return snapshot["rating"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "rating")
            }
          }

          public var location: String? {
            get {
              return snapshot["location"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "location")
            }
          }

          public var notes: String? {
            get {
              return snapshot["notes"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "notes")
            }
          }

          public var price: String? {
            get {
              return snapshot["price"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "price")
            }
          }

          public var pairings: [String] {
            get {
              return snapshot["pairings"]! as! [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "pairings")
            }
          }

          public var createdAt: String? {
            get {
              return snapshot["createdAt"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }
        }
      }

      public struct Friend: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFriendshipConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .list(.object(Item.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFriendshipConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?]? {
          get {
            return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Friendship"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("friendId", type: .nonNull(.scalar(GraphQLID.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, friendId: GraphQLID) {
            self.init(snapshot: ["__typename": "Friendship", "id": id, "friendId": friendId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var friendId: GraphQLID {
            get {
              return snapshot["friendId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "friendId")
            }
          }
        }
      }
    }
  }
}

public final class CreateFriendshipMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateFriendship($input: CreateFriendshipInput!) {\n  createFriendship(input: $input) {\n    __typename\n    id\n    user {\n      __typename\n      id\n      email\n      firstName\n      lastName\n    }\n    friendId\n  }\n}"

  public var input: CreateFriendshipInput

  public init(input: CreateFriendshipInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createFriendship", arguments: ["input": GraphQLVariable("input")], type: .object(CreateFriendship.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createFriendship: CreateFriendship? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createFriendship": createFriendship.flatMap { $0.snapshot }])
    }

    public var createFriendship: CreateFriendship? {
      get {
        return (snapshot["createFriendship"] as? Snapshot).flatMap { CreateFriendship(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createFriendship")
      }
    }

    public struct CreateFriendship: GraphQLSelectionSet {
      public static let possibleTypes = ["Friendship"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .nonNull(.object(User.selections))),
        GraphQLField("friendId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, user: User, friendId: GraphQLID) {
        self.init(snapshot: ["__typename": "Friendship", "id": id, "user": user.snapshot, "friendId": friendId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var user: User {
        get {
          return User(snapshot: snapshot["user"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "user")
        }
      }

      public var friendId: GraphQLID {
        get {
          return snapshot["friendId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "friendId")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String {
          get {
            return snapshot["email"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "email")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }
      }
    }
  }
}

public final class UpdateFriendshipMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateFriendship($input: UpdateFriendshipInput!) {\n  updateFriendship(input: $input) {\n    __typename\n    id\n    user {\n      __typename\n      id\n      email\n      firstName\n      lastName\n    }\n    friendId\n  }\n}"

  public var input: UpdateFriendshipInput

  public init(input: UpdateFriendshipInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateFriendship", arguments: ["input": GraphQLVariable("input")], type: .object(UpdateFriendship.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateFriendship: UpdateFriendship? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateFriendship": updateFriendship.flatMap { $0.snapshot }])
    }

    public var updateFriendship: UpdateFriendship? {
      get {
        return (snapshot["updateFriendship"] as? Snapshot).flatMap { UpdateFriendship(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateFriendship")
      }
    }

    public struct UpdateFriendship: GraphQLSelectionSet {
      public static let possibleTypes = ["Friendship"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .nonNull(.object(User.selections))),
        GraphQLField("friendId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, user: User, friendId: GraphQLID) {
        self.init(snapshot: ["__typename": "Friendship", "id": id, "user": user.snapshot, "friendId": friendId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var user: User {
        get {
          return User(snapshot: snapshot["user"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "user")
        }
      }

      public var friendId: GraphQLID {
        get {
          return snapshot["friendId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "friendId")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String {
          get {
            return snapshot["email"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "email")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }
      }
    }
  }
}

public final class DeleteFriendshipMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteFriendship($input: DeleteFriendshipInput!) {\n  deleteFriendship(input: $input) {\n    __typename\n    id\n    user {\n      __typename\n      id\n      email\n      firstName\n      lastName\n    }\n    friendId\n  }\n}"

  public var input: DeleteFriendshipInput

  public init(input: DeleteFriendshipInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteFriendship", arguments: ["input": GraphQLVariable("input")], type: .object(DeleteFriendship.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteFriendship: DeleteFriendship? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteFriendship": deleteFriendship.flatMap { $0.snapshot }])
    }

    public var deleteFriendship: DeleteFriendship? {
      get {
        return (snapshot["deleteFriendship"] as? Snapshot).flatMap { DeleteFriendship(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteFriendship")
      }
    }

    public struct DeleteFriendship: GraphQLSelectionSet {
      public static let possibleTypes = ["Friendship"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .nonNull(.object(User.selections))),
        GraphQLField("friendId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, user: User, friendId: GraphQLID) {
        self.init(snapshot: ["__typename": "Friendship", "id": id, "user": user.snapshot, "friendId": friendId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var user: User {
        get {
          return User(snapshot: snapshot["user"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "user")
        }
      }

      public var friendId: GraphQLID {
        get {
          return snapshot["friendId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "friendId")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String {
          get {
            return snapshot["email"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "email")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }
      }
    }
  }
}

public final class CreateWineMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateWine($input: CreateWineInput!) {\n  createWine(input: $input) {\n    __typename\n    id\n    user {\n      __typename\n      id\n      email\n      firstName\n      lastName\n    }\n    type\n    variety\n    name\n    rating\n    location\n    notes\n    price\n    pairings\n    createdAt\n  }\n}"

  public var input: CreateWineInput

  public init(input: CreateWineInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createWine", arguments: ["input": GraphQLVariable("input")], type: .object(CreateWine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createWine: CreateWine? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createWine": createWine.flatMap { $0.snapshot }])
    }

    public var createWine: CreateWine? {
      get {
        return (snapshot["createWine"] as? Snapshot).flatMap { CreateWine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createWine")
      }
    }

    public struct CreateWine: GraphQLSelectionSet {
      public static let possibleTypes = ["Wine"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("variety", type: .scalar(String.self)),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
        GraphQLField("location", type: .scalar(String.self)),
        GraphQLField("notes", type: .scalar(String.self)),
        GraphQLField("price", type: .scalar(String.self)),
        GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        GraphQLField("createdAt", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, user: User? = nil, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
        self.init(snapshot: ["__typename": "Wine", "id": id, "user": user.flatMap { $0.snapshot }, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var variety: String? {
        get {
          return snapshot["variety"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "variety")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var rating: Int {
        get {
          return snapshot["rating"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "rating")
        }
      }

      public var location: String? {
        get {
          return snapshot["location"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "location")
        }
      }

      public var notes: String? {
        get {
          return snapshot["notes"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "notes")
        }
      }

      public var price: String? {
        get {
          return snapshot["price"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "price")
        }
      }

      public var pairings: [String] {
        get {
          return snapshot["pairings"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "pairings")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String {
          get {
            return snapshot["email"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "email")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }
      }
    }
  }
}

public final class UpdateWineMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateWine($input: UpdateWineInput!) {\n  updateWine(input: $input) {\n    __typename\n    id\n    user {\n      __typename\n      id\n      email\n      firstName\n      lastName\n    }\n    type\n    variety\n    name\n    rating\n    location\n    notes\n    price\n    pairings\n    createdAt\n  }\n}"

  public var input: UpdateWineInput

  public init(input: UpdateWineInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateWine", arguments: ["input": GraphQLVariable("input")], type: .object(UpdateWine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateWine: UpdateWine? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateWine": updateWine.flatMap { $0.snapshot }])
    }

    public var updateWine: UpdateWine? {
      get {
        return (snapshot["updateWine"] as? Snapshot).flatMap { UpdateWine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateWine")
      }
    }

    public struct UpdateWine: GraphQLSelectionSet {
      public static let possibleTypes = ["Wine"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("variety", type: .scalar(String.self)),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
        GraphQLField("location", type: .scalar(String.self)),
        GraphQLField("notes", type: .scalar(String.self)),
        GraphQLField("price", type: .scalar(String.self)),
        GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        GraphQLField("createdAt", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, user: User? = nil, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
        self.init(snapshot: ["__typename": "Wine", "id": id, "user": user.flatMap { $0.snapshot }, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var variety: String? {
        get {
          return snapshot["variety"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "variety")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var rating: Int {
        get {
          return snapshot["rating"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "rating")
        }
      }

      public var location: String? {
        get {
          return snapshot["location"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "location")
        }
      }

      public var notes: String? {
        get {
          return snapshot["notes"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "notes")
        }
      }

      public var price: String? {
        get {
          return snapshot["price"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "price")
        }
      }

      public var pairings: [String] {
        get {
          return snapshot["pairings"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "pairings")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String {
          get {
            return snapshot["email"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "email")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }
      }
    }
  }
}

public final class DeleteWineMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteWine($input: DeleteWineInput!) {\n  deleteWine(input: $input) {\n    __typename\n    id\n    user {\n      __typename\n      id\n      email\n      firstName\n      lastName\n    }\n    type\n    variety\n    name\n    rating\n    location\n    notes\n    price\n    pairings\n    createdAt\n  }\n}"

  public var input: DeleteWineInput

  public init(input: DeleteWineInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteWine", arguments: ["input": GraphQLVariable("input")], type: .object(DeleteWine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteWine: DeleteWine? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteWine": deleteWine.flatMap { $0.snapshot }])
    }

    public var deleteWine: DeleteWine? {
      get {
        return (snapshot["deleteWine"] as? Snapshot).flatMap { DeleteWine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteWine")
      }
    }

    public struct DeleteWine: GraphQLSelectionSet {
      public static let possibleTypes = ["Wine"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("variety", type: .scalar(String.self)),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
        GraphQLField("location", type: .scalar(String.self)),
        GraphQLField("notes", type: .scalar(String.self)),
        GraphQLField("price", type: .scalar(String.self)),
        GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        GraphQLField("createdAt", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, user: User? = nil, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
        self.init(snapshot: ["__typename": "Wine", "id": id, "user": user.flatMap { $0.snapshot }, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var variety: String? {
        get {
          return snapshot["variety"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "variety")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var rating: Int {
        get {
          return snapshot["rating"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "rating")
        }
      }

      public var location: String? {
        get {
          return snapshot["location"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "location")
        }
      }

      public var notes: String? {
        get {
          return snapshot["notes"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "notes")
        }
      }

      public var price: String? {
        get {
          return snapshot["price"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "price")
        }
      }

      public var pairings: [String] {
        get {
          return snapshot["pairings"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "pairings")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String {
          get {
            return snapshot["email"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "email")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }
      }
    }
  }
}

public final class GetUserQuery: GraphQLQuery {
  public static let operationString =
    "query GetUser($id: ID!) {\n  getUser(id: $id) {\n    __typename\n    id\n    email\n    firstName\n    lastName\n    wines {\n      __typename\n      items {\n        __typename\n        id\n        type\n        variety\n        name\n        rating\n        location\n        notes\n        price\n        pairings\n        createdAt\n      }\n      nextToken\n    }\n    friends {\n      __typename\n      items {\n        __typename\n        id\n        friendId\n      }\n      nextToken\n    }\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getUser", arguments: ["id": GraphQLVariable("id")], type: .object(GetUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getUser: GetUser? = nil) {
      self.init(snapshot: ["__typename": "Query", "getUser": getUser.flatMap { $0.snapshot }])
    }

    public var getUser: GetUser? {
      get {
        return (snapshot["getUser"] as? Snapshot).flatMap { GetUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getUser")
      }
    }

    public struct GetUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("email", type: .nonNull(.scalar(String.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("wines", type: .object(Wine.selections)),
        GraphQLField("friends", type: .object(Friend.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil, wines: Wine? = nil, friends: Friend? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName, "wines": wines.flatMap { $0.snapshot }, "friends": friends.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var email: String {
        get {
          return snapshot["email"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "email")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var wines: Wine? {
        get {
          return (snapshot["wines"] as? Snapshot).flatMap { Wine(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "wines")
        }
      }

      public var friends: Friend? {
        get {
          return (snapshot["friends"] as? Snapshot).flatMap { Friend(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "friends")
        }
      }

      public struct Wine: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelWineConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .list(.object(Item.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelWineConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?]? {
          get {
            return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Wine"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("variety", type: .scalar(String.self)),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
            GraphQLField("location", type: .scalar(String.self)),
            GraphQLField("notes", type: .scalar(String.self)),
            GraphQLField("price", type: .scalar(String.self)),
            GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            GraphQLField("createdAt", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
            self.init(snapshot: ["__typename": "Wine", "id": id, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var variety: String? {
            get {
              return snapshot["variety"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "variety")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var rating: Int {
            get {
              return snapshot["rating"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "rating")
            }
          }

          public var location: String? {
            get {
              return snapshot["location"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "location")
            }
          }

          public var notes: String? {
            get {
              return snapshot["notes"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "notes")
            }
          }

          public var price: String? {
            get {
              return snapshot["price"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "price")
            }
          }

          public var pairings: [String] {
            get {
              return snapshot["pairings"]! as! [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "pairings")
            }
          }

          public var createdAt: String? {
            get {
              return snapshot["createdAt"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }
        }
      }

      public struct Friend: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFriendshipConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .list(.object(Item.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFriendshipConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?]? {
          get {
            return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Friendship"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("friendId", type: .nonNull(.scalar(GraphQLID.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, friendId: GraphQLID) {
            self.init(snapshot: ["__typename": "Friendship", "id": id, "friendId": friendId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var friendId: GraphQLID {
            get {
              return snapshot["friendId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "friendId")
            }
          }
        }
      }
    }
  }
}

public final class ListUsersQuery: GraphQLQuery {
  public static let operationString =
    "query ListUsers($filter: ModelUserFilterInput, $limit: Int, $nextToken: String) {\n  listUsers(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      email\n      firstName\n      lastName\n      wines {\n        __typename\n        items {\n          __typename\n          id\n          type\n          variety\n          name\n          rating\n          location\n          notes\n          price\n          pairings\n          createdAt\n        }\n        nextToken\n      }\n      friends {\n        __typename\n        items {\n          __typename\n          id\n          friendId\n        }\n        nextToken\n      }\n    }\n    nextToken\n  }\n}"

  public var filter: ModelUserFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelUserFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listUsers", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listUsers: ListUser? = nil) {
      self.init(snapshot: ["__typename": "Query", "listUsers": listUsers.flatMap { $0.snapshot }])
    }

    public var listUsers: ListUser? {
      get {
        return (snapshot["listUsers"] as? Snapshot).flatMap { ListUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listUsers")
      }
    }

    public struct ListUser: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelUserConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .list(.object(Item.selections))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?]? = nil, nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelUserConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?]? {
        get {
          return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
          GraphQLField("wines", type: .object(Wine.selections)),
          GraphQLField("friends", type: .object(Friend.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil, wines: Wine? = nil, friends: Friend? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName, "wines": wines.flatMap { $0.snapshot }, "friends": friends.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String {
          get {
            return snapshot["email"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "email")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public var wines: Wine? {
          get {
            return (snapshot["wines"] as? Snapshot).flatMap { Wine(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "wines")
          }
        }

        public var friends: Friend? {
          get {
            return (snapshot["friends"] as? Snapshot).flatMap { Friend(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "friends")
          }
        }

        public struct Wine: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelWineConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("items", type: .list(.object(Item.selections))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(items: [Item?]? = nil, nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelWineConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var items: [Item?]? {
            get {
              return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
            }
            set {
              snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }

          public struct Item: GraphQLSelectionSet {
            public static let possibleTypes = ["Wine"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("type", type: .nonNull(.scalar(String.self))),
              GraphQLField("variety", type: .scalar(String.self)),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
              GraphQLField("location", type: .scalar(String.self)),
              GraphQLField("notes", type: .scalar(String.self)),
              GraphQLField("price", type: .scalar(String.self)),
              GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
              GraphQLField("createdAt", type: .scalar(String.self)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(id: GraphQLID, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
              self.init(snapshot: ["__typename": "Wine", "id": id, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: GraphQLID {
              get {
                return snapshot["id"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "id")
              }
            }

            public var type: String {
              get {
                return snapshot["type"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "type")
              }
            }

            public var variety: String? {
              get {
                return snapshot["variety"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "variety")
              }
            }

            public var name: String {
              get {
                return snapshot["name"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "name")
              }
            }

            public var rating: Int {
              get {
                return snapshot["rating"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "rating")
              }
            }

            public var location: String? {
              get {
                return snapshot["location"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "location")
              }
            }

            public var notes: String? {
              get {
                return snapshot["notes"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "notes")
              }
            }

            public var price: String? {
              get {
                return snapshot["price"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "price")
              }
            }

            public var pairings: [String] {
              get {
                return snapshot["pairings"]! as! [String]
              }
              set {
                snapshot.updateValue(newValue, forKey: "pairings")
              }
            }

            public var createdAt: String? {
              get {
                return snapshot["createdAt"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "createdAt")
              }
            }
          }
        }

        public struct Friend: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelFriendshipConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("items", type: .list(.object(Item.selections))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(items: [Item?]? = nil, nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelFriendshipConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var items: [Item?]? {
            get {
              return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
            }
            set {
              snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }

          public struct Item: GraphQLSelectionSet {
            public static let possibleTypes = ["Friendship"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("friendId", type: .nonNull(.scalar(GraphQLID.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(id: GraphQLID, friendId: GraphQLID) {
              self.init(snapshot: ["__typename": "Friendship", "id": id, "friendId": friendId])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: GraphQLID {
              get {
                return snapshot["id"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "id")
              }
            }

            public var friendId: GraphQLID {
              get {
                return snapshot["friendId"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "friendId")
              }
            }
          }
        }
      }
    }
  }
}

public final class GetWineQuery: GraphQLQuery {
  public static let operationString =
    "query GetWine($id: ID!) {\n  getWine(id: $id) {\n    __typename\n    id\n    user {\n      __typename\n      id\n      email\n      firstName\n      lastName\n    }\n    type\n    variety\n    name\n    rating\n    location\n    notes\n    price\n    pairings\n    createdAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getWine", arguments: ["id": GraphQLVariable("id")], type: .object(GetWine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getWine: GetWine? = nil) {
      self.init(snapshot: ["__typename": "Query", "getWine": getWine.flatMap { $0.snapshot }])
    }

    public var getWine: GetWine? {
      get {
        return (snapshot["getWine"] as? Snapshot).flatMap { GetWine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getWine")
      }
    }

    public struct GetWine: GraphQLSelectionSet {
      public static let possibleTypes = ["Wine"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("variety", type: .scalar(String.self)),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
        GraphQLField("location", type: .scalar(String.self)),
        GraphQLField("notes", type: .scalar(String.self)),
        GraphQLField("price", type: .scalar(String.self)),
        GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        GraphQLField("createdAt", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, user: User? = nil, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
        self.init(snapshot: ["__typename": "Wine", "id": id, "user": user.flatMap { $0.snapshot }, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var variety: String? {
        get {
          return snapshot["variety"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "variety")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var rating: Int {
        get {
          return snapshot["rating"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "rating")
        }
      }

      public var location: String? {
        get {
          return snapshot["location"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "location")
        }
      }

      public var notes: String? {
        get {
          return snapshot["notes"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "notes")
        }
      }

      public var price: String? {
        get {
          return snapshot["price"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "price")
        }
      }

      public var pairings: [String] {
        get {
          return snapshot["pairings"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "pairings")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String {
          get {
            return snapshot["email"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "email")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }
      }
    }
  }
}

public final class ListWinesQuery: GraphQLQuery {
  public static let operationString =
    "query ListWines($filter: ModelWineFilterInput, $limit: Int, $nextToken: String) {\n  listWines(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      user {\n        __typename\n        id\n        email\n        firstName\n        lastName\n      }\n      type\n      variety\n      name\n      rating\n      location\n      notes\n      price\n      pairings\n      createdAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelWineFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelWineFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listWines", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListWine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listWines: ListWine? = nil) {
      self.init(snapshot: ["__typename": "Query", "listWines": listWines.flatMap { $0.snapshot }])
    }

    public var listWines: ListWine? {
      get {
        return (snapshot["listWines"] as? Snapshot).flatMap { ListWine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listWines")
      }
    }

    public struct ListWine: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelWineConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .list(.object(Item.selections))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?]? = nil, nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelWineConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?]? {
        get {
          return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Wine"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("user", type: .object(User.selections)),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("variety", type: .scalar(String.self)),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
          GraphQLField("location", type: .scalar(String.self)),
          GraphQLField("notes", type: .scalar(String.self)),
          GraphQLField("price", type: .scalar(String.self)),
          GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
          GraphQLField("createdAt", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, user: User? = nil, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
          self.init(snapshot: ["__typename": "Wine", "id": id, "user": user.flatMap { $0.snapshot }, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var user: User? {
          get {
            return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "user")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var variety: String? {
          get {
            return snapshot["variety"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "variety")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var rating: Int {
          get {
            return snapshot["rating"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "rating")
          }
        }

        public var location: String? {
          get {
            return snapshot["location"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "location")
          }
        }

        public var notes: String? {
          get {
            return snapshot["notes"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "notes")
          }
        }

        public var price: String? {
          get {
            return snapshot["price"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "price")
          }
        }

        public var pairings: [String] {
          get {
            return snapshot["pairings"]! as! [String]
          }
          set {
            snapshot.updateValue(newValue, forKey: "pairings")
          }
        }

        public var createdAt: String? {
          get {
            return snapshot["createdAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("email", type: .nonNull(.scalar(String.self))),
            GraphQLField("firstName", type: .scalar(String.self)),
            GraphQLField("lastName", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil) {
            self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var email: String {
            get {
              return snapshot["email"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "email")
            }
          }

          public var firstName: String? {
            get {
              return snapshot["firstName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "firstName")
            }
          }

          public var lastName: String? {
            get {
              return snapshot["lastName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "lastName")
            }
          }
        }
      }
    }
  }
}

public final class OnCreateUserSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateUser {\n  onCreateUser {\n    __typename\n    id\n    email\n    firstName\n    lastName\n    wines {\n      __typename\n      items {\n        __typename\n        id\n        type\n        variety\n        name\n        rating\n        location\n        notes\n        price\n        pairings\n        createdAt\n      }\n      nextToken\n    }\n    friends {\n      __typename\n      items {\n        __typename\n        id\n        friendId\n      }\n      nextToken\n    }\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateUser", type: .object(OnCreateUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateUser: OnCreateUser? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateUser": onCreateUser.flatMap { $0.snapshot }])
    }

    public var onCreateUser: OnCreateUser? {
      get {
        return (snapshot["onCreateUser"] as? Snapshot).flatMap { OnCreateUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateUser")
      }
    }

    public struct OnCreateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("email", type: .nonNull(.scalar(String.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("wines", type: .object(Wine.selections)),
        GraphQLField("friends", type: .object(Friend.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil, wines: Wine? = nil, friends: Friend? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName, "wines": wines.flatMap { $0.snapshot }, "friends": friends.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var email: String {
        get {
          return snapshot["email"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "email")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var wines: Wine? {
        get {
          return (snapshot["wines"] as? Snapshot).flatMap { Wine(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "wines")
        }
      }

      public var friends: Friend? {
        get {
          return (snapshot["friends"] as? Snapshot).flatMap { Friend(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "friends")
        }
      }

      public struct Wine: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelWineConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .list(.object(Item.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelWineConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?]? {
          get {
            return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Wine"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("variety", type: .scalar(String.self)),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
            GraphQLField("location", type: .scalar(String.self)),
            GraphQLField("notes", type: .scalar(String.self)),
            GraphQLField("price", type: .scalar(String.self)),
            GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            GraphQLField("createdAt", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
            self.init(snapshot: ["__typename": "Wine", "id": id, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var variety: String? {
            get {
              return snapshot["variety"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "variety")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var rating: Int {
            get {
              return snapshot["rating"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "rating")
            }
          }

          public var location: String? {
            get {
              return snapshot["location"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "location")
            }
          }

          public var notes: String? {
            get {
              return snapshot["notes"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "notes")
            }
          }

          public var price: String? {
            get {
              return snapshot["price"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "price")
            }
          }

          public var pairings: [String] {
            get {
              return snapshot["pairings"]! as! [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "pairings")
            }
          }

          public var createdAt: String? {
            get {
              return snapshot["createdAt"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }
        }
      }

      public struct Friend: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFriendshipConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .list(.object(Item.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFriendshipConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?]? {
          get {
            return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Friendship"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("friendId", type: .nonNull(.scalar(GraphQLID.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, friendId: GraphQLID) {
            self.init(snapshot: ["__typename": "Friendship", "id": id, "friendId": friendId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var friendId: GraphQLID {
            get {
              return snapshot["friendId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "friendId")
            }
          }
        }
      }
    }
  }
}

public final class OnUpdateUserSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateUser {\n  onUpdateUser {\n    __typename\n    id\n    email\n    firstName\n    lastName\n    wines {\n      __typename\n      items {\n        __typename\n        id\n        type\n        variety\n        name\n        rating\n        location\n        notes\n        price\n        pairings\n        createdAt\n      }\n      nextToken\n    }\n    friends {\n      __typename\n      items {\n        __typename\n        id\n        friendId\n      }\n      nextToken\n    }\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateUser", type: .object(OnUpdateUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateUser: OnUpdateUser? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateUser": onUpdateUser.flatMap { $0.snapshot }])
    }

    public var onUpdateUser: OnUpdateUser? {
      get {
        return (snapshot["onUpdateUser"] as? Snapshot).flatMap { OnUpdateUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateUser")
      }
    }

    public struct OnUpdateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("email", type: .nonNull(.scalar(String.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("wines", type: .object(Wine.selections)),
        GraphQLField("friends", type: .object(Friend.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil, wines: Wine? = nil, friends: Friend? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName, "wines": wines.flatMap { $0.snapshot }, "friends": friends.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var email: String {
        get {
          return snapshot["email"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "email")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var wines: Wine? {
        get {
          return (snapshot["wines"] as? Snapshot).flatMap { Wine(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "wines")
        }
      }

      public var friends: Friend? {
        get {
          return (snapshot["friends"] as? Snapshot).flatMap { Friend(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "friends")
        }
      }

      public struct Wine: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelWineConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .list(.object(Item.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelWineConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?]? {
          get {
            return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Wine"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("variety", type: .scalar(String.self)),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
            GraphQLField("location", type: .scalar(String.self)),
            GraphQLField("notes", type: .scalar(String.self)),
            GraphQLField("price", type: .scalar(String.self)),
            GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            GraphQLField("createdAt", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
            self.init(snapshot: ["__typename": "Wine", "id": id, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var variety: String? {
            get {
              return snapshot["variety"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "variety")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var rating: Int {
            get {
              return snapshot["rating"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "rating")
            }
          }

          public var location: String? {
            get {
              return snapshot["location"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "location")
            }
          }

          public var notes: String? {
            get {
              return snapshot["notes"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "notes")
            }
          }

          public var price: String? {
            get {
              return snapshot["price"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "price")
            }
          }

          public var pairings: [String] {
            get {
              return snapshot["pairings"]! as! [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "pairings")
            }
          }

          public var createdAt: String? {
            get {
              return snapshot["createdAt"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }
        }
      }

      public struct Friend: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFriendshipConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .list(.object(Item.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFriendshipConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?]? {
          get {
            return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Friendship"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("friendId", type: .nonNull(.scalar(GraphQLID.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, friendId: GraphQLID) {
            self.init(snapshot: ["__typename": "Friendship", "id": id, "friendId": friendId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var friendId: GraphQLID {
            get {
              return snapshot["friendId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "friendId")
            }
          }
        }
      }
    }
  }
}

public final class OnDeleteUserSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteUser {\n  onDeleteUser {\n    __typename\n    id\n    email\n    firstName\n    lastName\n    wines {\n      __typename\n      items {\n        __typename\n        id\n        type\n        variety\n        name\n        rating\n        location\n        notes\n        price\n        pairings\n        createdAt\n      }\n      nextToken\n    }\n    friends {\n      __typename\n      items {\n        __typename\n        id\n        friendId\n      }\n      nextToken\n    }\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteUser", type: .object(OnDeleteUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteUser: OnDeleteUser? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteUser": onDeleteUser.flatMap { $0.snapshot }])
    }

    public var onDeleteUser: OnDeleteUser? {
      get {
        return (snapshot["onDeleteUser"] as? Snapshot).flatMap { OnDeleteUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteUser")
      }
    }

    public struct OnDeleteUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("email", type: .nonNull(.scalar(String.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("wines", type: .object(Wine.selections)),
        GraphQLField("friends", type: .object(Friend.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil, wines: Wine? = nil, friends: Friend? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName, "wines": wines.flatMap { $0.snapshot }, "friends": friends.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var email: String {
        get {
          return snapshot["email"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "email")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var wines: Wine? {
        get {
          return (snapshot["wines"] as? Snapshot).flatMap { Wine(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "wines")
        }
      }

      public var friends: Friend? {
        get {
          return (snapshot["friends"] as? Snapshot).flatMap { Friend(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "friends")
        }
      }

      public struct Wine: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelWineConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .list(.object(Item.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelWineConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?]? {
          get {
            return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Wine"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("variety", type: .scalar(String.self)),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
            GraphQLField("location", type: .scalar(String.self)),
            GraphQLField("notes", type: .scalar(String.self)),
            GraphQLField("price", type: .scalar(String.self)),
            GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            GraphQLField("createdAt", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
            self.init(snapshot: ["__typename": "Wine", "id": id, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var variety: String? {
            get {
              return snapshot["variety"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "variety")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var rating: Int {
            get {
              return snapshot["rating"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "rating")
            }
          }

          public var location: String? {
            get {
              return snapshot["location"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "location")
            }
          }

          public var notes: String? {
            get {
              return snapshot["notes"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "notes")
            }
          }

          public var price: String? {
            get {
              return snapshot["price"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "price")
            }
          }

          public var pairings: [String] {
            get {
              return snapshot["pairings"]! as! [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "pairings")
            }
          }

          public var createdAt: String? {
            get {
              return snapshot["createdAt"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }
        }
      }

      public struct Friend: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFriendshipConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .list(.object(Item.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFriendshipConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?]? {
          get {
            return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Friendship"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("friendId", type: .nonNull(.scalar(GraphQLID.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, friendId: GraphQLID) {
            self.init(snapshot: ["__typename": "Friendship", "id": id, "friendId": friendId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var friendId: GraphQLID {
            get {
              return snapshot["friendId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "friendId")
            }
          }
        }
      }
    }
  }
}

public final class OnCreateFriendshipSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateFriendship {\n  onCreateFriendship {\n    __typename\n    id\n    user {\n      __typename\n      id\n      email\n      firstName\n      lastName\n    }\n    friendId\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateFriendship", type: .object(OnCreateFriendship.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateFriendship: OnCreateFriendship? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateFriendship": onCreateFriendship.flatMap { $0.snapshot }])
    }

    public var onCreateFriendship: OnCreateFriendship? {
      get {
        return (snapshot["onCreateFriendship"] as? Snapshot).flatMap { OnCreateFriendship(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateFriendship")
      }
    }

    public struct OnCreateFriendship: GraphQLSelectionSet {
      public static let possibleTypes = ["Friendship"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .nonNull(.object(User.selections))),
        GraphQLField("friendId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, user: User, friendId: GraphQLID) {
        self.init(snapshot: ["__typename": "Friendship", "id": id, "user": user.snapshot, "friendId": friendId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var user: User {
        get {
          return User(snapshot: snapshot["user"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "user")
        }
      }

      public var friendId: GraphQLID {
        get {
          return snapshot["friendId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "friendId")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String {
          get {
            return snapshot["email"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "email")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }
      }
    }
  }
}

public final class OnUpdateFriendshipSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateFriendship {\n  onUpdateFriendship {\n    __typename\n    id\n    user {\n      __typename\n      id\n      email\n      firstName\n      lastName\n    }\n    friendId\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateFriendship", type: .object(OnUpdateFriendship.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateFriendship: OnUpdateFriendship? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateFriendship": onUpdateFriendship.flatMap { $0.snapshot }])
    }

    public var onUpdateFriendship: OnUpdateFriendship? {
      get {
        return (snapshot["onUpdateFriendship"] as? Snapshot).flatMap { OnUpdateFriendship(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateFriendship")
      }
    }

    public struct OnUpdateFriendship: GraphQLSelectionSet {
      public static let possibleTypes = ["Friendship"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .nonNull(.object(User.selections))),
        GraphQLField("friendId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, user: User, friendId: GraphQLID) {
        self.init(snapshot: ["__typename": "Friendship", "id": id, "user": user.snapshot, "friendId": friendId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var user: User {
        get {
          return User(snapshot: snapshot["user"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "user")
        }
      }

      public var friendId: GraphQLID {
        get {
          return snapshot["friendId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "friendId")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String {
          get {
            return snapshot["email"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "email")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }
      }
    }
  }
}

public final class OnDeleteFriendshipSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteFriendship {\n  onDeleteFriendship {\n    __typename\n    id\n    user {\n      __typename\n      id\n      email\n      firstName\n      lastName\n    }\n    friendId\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteFriendship", type: .object(OnDeleteFriendship.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteFriendship: OnDeleteFriendship? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteFriendship": onDeleteFriendship.flatMap { $0.snapshot }])
    }

    public var onDeleteFriendship: OnDeleteFriendship? {
      get {
        return (snapshot["onDeleteFriendship"] as? Snapshot).flatMap { OnDeleteFriendship(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteFriendship")
      }
    }

    public struct OnDeleteFriendship: GraphQLSelectionSet {
      public static let possibleTypes = ["Friendship"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .nonNull(.object(User.selections))),
        GraphQLField("friendId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, user: User, friendId: GraphQLID) {
        self.init(snapshot: ["__typename": "Friendship", "id": id, "user": user.snapshot, "friendId": friendId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var user: User {
        get {
          return User(snapshot: snapshot["user"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "user")
        }
      }

      public var friendId: GraphQLID {
        get {
          return snapshot["friendId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "friendId")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String {
          get {
            return snapshot["email"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "email")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }
      }
    }
  }
}

public final class OnCreateWineSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateWine {\n  onCreateWine {\n    __typename\n    id\n    user {\n      __typename\n      id\n      email\n      firstName\n      lastName\n    }\n    type\n    variety\n    name\n    rating\n    location\n    notes\n    price\n    pairings\n    createdAt\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateWine", type: .object(OnCreateWine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateWine: OnCreateWine? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateWine": onCreateWine.flatMap { $0.snapshot }])
    }

    public var onCreateWine: OnCreateWine? {
      get {
        return (snapshot["onCreateWine"] as? Snapshot).flatMap { OnCreateWine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateWine")
      }
    }

    public struct OnCreateWine: GraphQLSelectionSet {
      public static let possibleTypes = ["Wine"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("variety", type: .scalar(String.self)),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
        GraphQLField("location", type: .scalar(String.self)),
        GraphQLField("notes", type: .scalar(String.self)),
        GraphQLField("price", type: .scalar(String.self)),
        GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        GraphQLField("createdAt", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, user: User? = nil, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
        self.init(snapshot: ["__typename": "Wine", "id": id, "user": user.flatMap { $0.snapshot }, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var variety: String? {
        get {
          return snapshot["variety"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "variety")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var rating: Int {
        get {
          return snapshot["rating"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "rating")
        }
      }

      public var location: String? {
        get {
          return snapshot["location"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "location")
        }
      }

      public var notes: String? {
        get {
          return snapshot["notes"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "notes")
        }
      }

      public var price: String? {
        get {
          return snapshot["price"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "price")
        }
      }

      public var pairings: [String] {
        get {
          return snapshot["pairings"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "pairings")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String {
          get {
            return snapshot["email"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "email")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }
      }
    }
  }
}

public final class OnUpdateWineSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateWine {\n  onUpdateWine {\n    __typename\n    id\n    user {\n      __typename\n      id\n      email\n      firstName\n      lastName\n    }\n    type\n    variety\n    name\n    rating\n    location\n    notes\n    price\n    pairings\n    createdAt\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateWine", type: .object(OnUpdateWine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateWine: OnUpdateWine? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateWine": onUpdateWine.flatMap { $0.snapshot }])
    }

    public var onUpdateWine: OnUpdateWine? {
      get {
        return (snapshot["onUpdateWine"] as? Snapshot).flatMap { OnUpdateWine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateWine")
      }
    }

    public struct OnUpdateWine: GraphQLSelectionSet {
      public static let possibleTypes = ["Wine"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("variety", type: .scalar(String.self)),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
        GraphQLField("location", type: .scalar(String.self)),
        GraphQLField("notes", type: .scalar(String.self)),
        GraphQLField("price", type: .scalar(String.self)),
        GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        GraphQLField("createdAt", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, user: User? = nil, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
        self.init(snapshot: ["__typename": "Wine", "id": id, "user": user.flatMap { $0.snapshot }, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var variety: String? {
        get {
          return snapshot["variety"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "variety")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var rating: Int {
        get {
          return snapshot["rating"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "rating")
        }
      }

      public var location: String? {
        get {
          return snapshot["location"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "location")
        }
      }

      public var notes: String? {
        get {
          return snapshot["notes"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "notes")
        }
      }

      public var price: String? {
        get {
          return snapshot["price"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "price")
        }
      }

      public var pairings: [String] {
        get {
          return snapshot["pairings"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "pairings")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String {
          get {
            return snapshot["email"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "email")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }
      }
    }
  }
}

public final class OnDeleteWineSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteWine {\n  onDeleteWine {\n    __typename\n    id\n    user {\n      __typename\n      id\n      email\n      firstName\n      lastName\n    }\n    type\n    variety\n    name\n    rating\n    location\n    notes\n    price\n    pairings\n    createdAt\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteWine", type: .object(OnDeleteWine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteWine: OnDeleteWine? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteWine": onDeleteWine.flatMap { $0.snapshot }])
    }

    public var onDeleteWine: OnDeleteWine? {
      get {
        return (snapshot["onDeleteWine"] as? Snapshot).flatMap { OnDeleteWine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteWine")
      }
    }

    public struct OnDeleteWine: GraphQLSelectionSet {
      public static let possibleTypes = ["Wine"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("variety", type: .scalar(String.self)),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("rating", type: .nonNull(.scalar(Int.self))),
        GraphQLField("location", type: .scalar(String.self)),
        GraphQLField("notes", type: .scalar(String.self)),
        GraphQLField("price", type: .scalar(String.self)),
        GraphQLField("pairings", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        GraphQLField("createdAt", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, user: User? = nil, type: String, variety: String? = nil, name: String, rating: Int, location: String? = nil, notes: String? = nil, price: String? = nil, pairings: [String], createdAt: String? = nil) {
        self.init(snapshot: ["__typename": "Wine", "id": id, "user": user.flatMap { $0.snapshot }, "type": type, "variety": variety, "name": name, "rating": rating, "location": location, "notes": notes, "price": price, "pairings": pairings, "createdAt": createdAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var variety: String? {
        get {
          return snapshot["variety"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "variety")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var rating: Int {
        get {
          return snapshot["rating"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "rating")
        }
      }

      public var location: String? {
        get {
          return snapshot["location"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "location")
        }
      }

      public var notes: String? {
        get {
          return snapshot["notes"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "notes")
        }
      }

      public var price: String? {
        get {
          return snapshot["price"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "price")
        }
      }

      public var pairings: [String] {
        get {
          return snapshot["pairings"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "pairings")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "email": email, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String {
          get {
            return snapshot["email"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "email")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }
      }
    }
  }
}