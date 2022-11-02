import Fluent
import Vapor


//MIGRATION MODEL
struct CreateProduct: Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("product")
            .id()
            .field("title", .string, .required)
            .field("description", .string, .required)
            .field("price", .int, .required)
            .field("category", .string, .required)
            .field("image", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("product").delete()
    }
}
