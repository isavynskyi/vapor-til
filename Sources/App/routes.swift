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
    
    router.post("api", "acronyms") { req -> Future<Acronym> in
        return try req.content.decode(Acronym.self).flatMap(to: Acronym.self) { acronym in
            return acronym.save(on: req)
        }
    }
    
    // 1
    router.get("api", "acronyms") { req -> Future<[Acronym]> in
        // 2
        return Acronym.query(on: req).all()
    }
    
    // 1
    router.get("api", "acronyms", Acronym.parameter) {
        req -> Future<Acronym> in
        // 2
        return try req.parameters.next(Acronym.self)
    }
    
    // 1
    router.put("api", "acronyms", Acronym.parameter) {
        req -> Future<Acronym> in
        // 2
        return try flatMap(to: Acronym.self,
                           req.parameters.next(Acronym.self),
                           req.content.decode(Acronym.self)) {
                            acronym, updatedAcronym in
                            // 3
                            acronym.short = updatedAcronym.short
                            acronym.long = updatedAcronym.long
                            // 4
                            return acronym.save(on: req)
        }
    }
    
    // 1
    router.delete("api", "acronyms", Acronym.parameter) {
        req -> Future<HTTPStatus> in
        // 2
        return try req.parameters.next(Acronym.self)
            // 3
            .delete(on: req)
            // 4
            .transform(to: HTTPStatus.noContent)
    }
    
    
    // 1
    router.get("api", "acronyms", "search") {
        req -> Future<[Acronym]> in
        // 2
        guard
            let searchTerm = req.query[String.self, at: "term"] else {
                throw Abort(.badRequest)
        }
        // 3
        // 1
        return Acronym.query(on: req).group(.or) { or in
            // 2
            or.filter(\.short == searchTerm)
            or.filter(\.long == searchTerm)
            }.all()
    }
    
    
    // 1
    router.get("api", "acronyms", "first") {
        req -> Future<Acronym> in
        // 2
        return Acronym.query(on: req)
            // 3
            .first()
            .map(to: Acronym.self) { acronym in
                guard let acronym = acronym else {
                    throw Abort(.notFound)
                }
                // 4
                return acronym
        }
    }
    
    // 1
    router.get("api", "acronyms", "sorted") {
        req -> Future<[Acronym]> in
        // 2
        return Acronym.query(on: req)
        .sort(\.short, .ascending)
        .all()
    }

    
}
