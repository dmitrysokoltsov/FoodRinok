import Fluent
import Vapor

struct ProductController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let productGroup = routes.grouped("product")
        productGroup.post(use: createHandler)
        productGroup.get(use: getAllHandler)
        productGroup.get(":poductID", use: getHandler)
    }
    
    /// Create content model for post request to db
    /// - Parameter req: Product model to db
    /// - Returns: Content model
    func createHandler(_ req: Request) async throws -> Product {
        guard let product = try? req.content.decode(Product.self) else {
            throw Abort(.custom(code: 444, reasonPhrase: "Content model decode error"))
        }
        
        try await product.save(on: req.db)
        return product
    }
    
    /// Get poduct from parameters (id) from db
    /// - Parameter req: Poduct from db
    /// - Returns: Content model of product by parameters(id)
    func getHandler(_ req: Request) async throws -> Product {
        guard let product = try await Product.find(req.parameters.get("poductID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return product
    }
    
    /// Get all product from db
    /// - Parameter req: Product from db
    /// - Returns: Arrey content model of all product
    func getAllHandler(_ req: Request) async throws -> [Product] {
        guard let product = try? await Product.query(on: req.db).all() else {
            throw Abort(.custom(code: 445, reasonPhrase: "Return all product error"))
        }
        return product
    }
}
