import Vapor
struct CategoriesController: RouteCollection {
    func boot(router: Router) throws {
        let categoriesRoute = router.grouped("api", "categories")

        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = categoriesRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        tokenAuthGroup.post(Category.self, use: createHandler)
        
        categoriesRoute.get(use: getAllHandler)
        categoriesRoute.get(Category.parameter, use: getHandler)
        categoriesRoute.get(Category.parameter, "acronyms", use: getAcronymsHandler)
    }
    
    // 5
    func createHandler(
        _ req: Request,
        category: Category
        ) throws -> Future<Category> {
        // 6
        return category.save(on: req)
    }
    // 7
    func getAllHandler(
        _ req: Request
        ) throws -> Future<[Category]> {
        // 8
        return Category.query(on: req).all()
    }
    // 9
    func getHandler(_ req: Request) throws -> Future<Category> {
        // 10
        return try req.parameters.next(Category.self)
    }
    
    // 1
    func getAcronymsHandler(
        _ req: Request
        ) throws -> Future<[Acronym]> {
        // 2
        return try req.parameters.next(Category.self)
            .flatMap(to: [Acronym].self) { category in
                // 3
                try category.acronyms.query(on: req).all()
        }
    }
    
}
