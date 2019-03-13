import Routing
import Vapor
import Fluent

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    // 1
    let acronymsController = AcronymsController()
    try router.register(collection: acronymsController)
    
    // 2
    let usersController = UsersController()
    do {
        try router.register(collection: usersController)
    } catch {
        print(error)
    }
}
