import Vapor
import HTMLKit

///// An extension that implements most of the helper functions
extension HTMLRenderable {

    /// Renders a `TemplateView` formula
    ///
    ///     try renderer.render(WelcomeView.self)
    ///
    /// - Parameters:
    ///   - type: The view type to render
    ///   - context: The needed context to render the view with
    /// - Returns: Returns a rendered view in a `HTTPResponse`
    /// - Throws: If the formula do not exists, or if the rendering process fails
    func render<T: HTMLTemplate>(_ type: T.Type, with context: T.Context) throws -> HTTPResponse {
        return try HTTPResponse(headers: .init([("content-type", "text/html; charset=utf-8")]), body: render(raw: type, with: context))
    }

    /// Renders a `StaticView` formula
    ///
    ///     try renderer.render(WelcomeView.self)
    ///
    /// - Parameter type: The view type to render
    /// - Returns: Returns a rendered view in a `HTTPResponse`
    /// - Throws: If the formula do not exists, or if the rendering process fails
    func render<T>(_ type: T.Type) throws -> HTTPResponse where T: HTMLPage {
        return try HTTPResponse(headers: .init([("content-type", "text/html; charset=utf-8")]), body: render(raw: type))
    }
}

/// Captures all errors and transforms them into an internal server error.
public final class HTMLKitErrorMiddleware<F: HTMLPage, S: HTMLTemplate>: Middleware, Service where S.Context == HTTPStatus {

    /// Create a new ErrorMiddleware for the supplied pages.
    public init(notFoundPage: F.Type, serverErrorTemplate: S.Type) {}

    /// Create a new ErrorMiddleware
    public init() {}

    /// See `Middleware.respond`
    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        do {
            return try next.respond(to: req).flatMap(to: Response.self) { res in
                if res.http.status.code >= HTTPResponseStatus.badRequest.code {
                    return try self.handleError(for: req, status: res.http.status)
                } else {
                    return try res.encode(for: req)
                }
                }.catchFlatMap { error in
                    switch error {
                    case let abort as AbortError:
                        return try self.handleError(for: req, status: abort.status)
                    default:
                        return try self.handleError(for: req, status: .internalServerError)
                    }
            }
        } catch {
            return try handleError(for: req, status: HTTPStatus(error))
        }
    }

    private func handleError(for req: Request, status: HTTPStatus) throws -> Future<Response> {
        let renderer = try req.make(HTMLRenderer.self)

        if status == .notFound {
            do {
                return try renderer.render(F.self).encode(for: req).map(to: Response.self) { res in
                    res.http.status = status
                    return res
                    }.catchFlatMap { _ in
                        return try self.renderServerErrorPage(for: status, request: req, renderer: renderer)
                }
            } catch {
                let logger = try req.make(Logger.self)
                logger.error("Failed to render custom error page - \(error)")
                return try renderServerErrorPage(for: status, request: req, renderer: renderer)
            }
        }

        return try renderServerErrorPage(for: status, request: req, renderer: renderer)
    }

    private func renderServerErrorPage(for status: HTTPStatus, request: Request, renderer: HTMLRenderable) throws -> Future<Response> {

        let logger = try request.make(Logger.self)
        logger.error("Internal server error. Status: \(status.code) - path: \(request.http.url)")

        do {
            return try renderer.render(S.self, with: status).encode(for: request).map(to: Response.self) { res in
                res.http.status = status
                return res
                }.catchFlatMap { error -> Future<Response> in
                    return try self.presentDefaultError(status: status, request: request, error: error)
            }
        } catch let error {
            logger.error("Failed to render custom error page - \(error)")
            return try presentDefaultError(status: status, request: request, error: error)
        }
    }

    private func presentDefaultError(status: HTTPStatus, request: Request, error: Error) throws -> Future<Response> {
        let body = "<h1>Internal Error</h1><p>There was an internal error. Please try again later.</p>"
        let logger = try request.make(Logger.self)
        logger.error("Failed to render custom error page - \(error)")
        return try body.encode(for: request)
            .map(to: Response.self) { res in
                res.http.status = status
                res.http.headers.replaceOrAdd(name: .contentType, value: "text/html; charset=utf-8")
                return res
        }
    }
}

extension HTTPStatus {
    internal init(_ error: Error) {
        if let abort = error as? AbortError {
            self = abort.status
        } else {
            self = .internalServerError
        }
    }
}
