public protocol ContentRouter: AnyObject {
    
    func route(_ content: AnyContentRepresentation) throws
    
}

// MARK: - Convenience Routing

extension ContentRouter {
    
    public func route<Content>(_ content: Content) throws where Content: ContentRepresentation {
        try route(content.eraseToAnyContentRepresentation())
    }
    
}
