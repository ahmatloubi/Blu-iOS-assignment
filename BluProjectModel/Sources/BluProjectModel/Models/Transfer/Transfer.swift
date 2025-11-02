import Foundation
import CoreNetwork

public struct Transfer: Codable, Sendable, Hashable, Identifiable {
    public let person: Person
    @DateTime public var lastTransfer: Date?
    public let note: String?
    public let card: Card
    public let moreInfo: MoreInfo
    
    public init(person: Person, lastTransfer: Date? = nil, note: String?, card: Card, moreInfo: MoreInfo) {
        self.person = person
        self.lastTransfer = lastTransfer
        self.note = note
        self.card = card
        self.moreInfo = moreInfo
    }
    
    public var id: Int {
        return hashValue
    }
    
}
