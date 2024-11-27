//
//  ResultProducts.swift
//  ListProducts
//
//  Created by Kike Hernandez D. on 26/11/24.
//

import Foundation
import Alamofire

typealias Product = Record
typealias Products = [Record]

typealias LSResponse<T: Codable> = (AFResult<T>) -> Void

// MARK: - Result
struct Result: Codable {
    let status: Status?
    let pageType: String?
    let plpResults: PlpResults?
    let nullSearch: String?
}

// MARK: - PlpResults
struct PlpResults: Codable {
    let label: String?
    let plpState: PlpState?
    let sortOptions: [SortOption]?
    let refinementGroups: [RefinementGroup]?
    let records: [Record]?
    let navigation: Navigation?
    let metaData: MetaData?
    let redirectTo404, enableMinNumOfPieces: Bool?
}

// MARK: - MetaData
struct MetaData: Codable {
    let searchAttributionToken: String?
    let cached: Bool?
    let totalTime: Int?
}

// MARK: - Navigation
struct Navigation: Codable {
    let ancester, current: [Ancester]?
}

// MARK: - Ancester
struct Ancester: Codable {
    let label, categoryID: String?

    enum CodingKeys: String, CodingKey {
        case label
        case categoryID = "categoryId"
    }
}

// MARK: - PlpState
struct PlpState: Codable {
    let categoryID, currentSortOption, currentFilters: String?
    let firstRecNum, lastRecNum, recsPerPage, totalNumRecs: Int?
    let originalSearchTerm, plpSellerName, area, id: String?

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case currentSortOption, currentFilters, firstRecNum, lastRecNum, recsPerPage, totalNumRecs, originalSearchTerm, plpSellerName, area, id
    }
}

// MARK: - Record
struct Record: Identifiable, Equatable, Codable {
    let productID, skuRepositoryID, productDisplayName: String?
    let productType: String?
    let productRatingCount: Int?
    let productAvgRating: Double?
    let promotionalGiftMessage: String?
    let listPrice, minimumListPrice, maximumListPrice: Int?
    let promoPrice, minimumPromoPrice, maximumPromoPrice: Double?
    let isHybrid, isMarketPlace, isImportationProduct: Bool?
    let brand: String?
    let ar: Bool?
    let seller: String?
    let category: String?
    let dwPromotionInfo: DWPromotionInfo?
    let categoryBreadCrumbs: [String]?
    let galleryImagesVariants: [String]?
    let smImage, lgImage, xlImage: String?
    let groupType: String?
    let variantsColor: [VariantsColor]?
    let enableTryOn: Bool?
    
    var id: String {
        return self.productID ?? ""
    }
    
    static func == (lhs: Record, rhs: Record) -> Bool {
        return true
    }

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case skuRepositoryID = "skuRepositoryId"
        case productDisplayName, productType, productRatingCount, productAvgRating, promotionalGiftMessage, listPrice, minimumListPrice, maximumListPrice, promoPrice, minimumPromoPrice, maximumPromoPrice, isHybrid, isMarketPlace, isImportationProduct, brand, ar, seller, category, dwPromotionInfo, categoryBreadCrumbs, galleryImagesVariants, smImage, lgImage, xlImage, groupType, variantsColor, enableTryOn
    }
}

enum Category: String, Codable {
    case aéropostale = "Aéropostale"
    case bananaRepublic = "Banana Republic"
    case map = "MAP"
    case mujer = "Mujer"
    case puntRoma = "Punt Roma"
}

// MARK: - DWPromotionInfo
struct DWPromotionInfo: Codable {
    let dwToolTipInfo: String?
    let dWPromoDescription: String?
}

enum DWPromoDescription: String, Codable {
    case empty = ""
    case yORecibeStrong20StrongEnMonedero = "Y/o recibe <strong>20</strong>% en monedero"
}

enum GroupType: String, Codable {
    case notSpecified = "Not Specified"
}

enum ProductType: String, Codable {
    case softLine = "Soft Line"
}

enum PromotionalGiftMessage: String, Codable {
    case na = "NA"
}

enum Seller: String, Codable {
    case bananarepublic = "bananarepublic"
    case liverpool = "liverpool"
    case supply = "Supply"
}

// MARK: - VariantsColor
struct VariantsColor: Codable, Identifiable  {
    let id = UUID()
    let colorName, colorHex, colorImageURL: String?
    let colorMainURL: String?
    let skuID: String?
    let galleryImages: [String]?

    enum CodingKeys: String, CodingKey {
        case colorName, colorHex, colorImageURL, colorMainURL
        case skuID = "skuId"
        case galleryImages
    }
}

// MARK: - RefinementGroup
struct RefinementGroup: Codable {
    let name: String?
    let refinement: [Refinement]?
    let multiSelect: Bool?
    let dimensionName: String?
    let moreRefinements: Bool?
}

// MARK: - Refinement
struct Refinement: Codable {
    let count: Int?
    let label, refinementID: String?
    let selected: Bool?
    let type: String?
    let searchName: String?
    let high, low, colorHex: String?

    enum CodingKeys: String, CodingKey {
        case count, label
        case refinementID = "refinementId"
        case selected, type, searchName, high, low, colorHex
    }
}

enum SearchName: String, Codable {
    case categories1 = "categories.1"
}

enum TypeEnum: String, Codable {
    case range = "Range"
    case value = "Value"
}

// MARK: - SortOption
struct SortOption: Codable {
    let sortBy, label: String?
}

// MARK: - Status
struct Status: Codable {
    let status: String?
    let statusCode: Int?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
            return nil
    }

    required init?(stringValue: String) {
            key = stringValue
    }

    var intValue: Int? {
            return nil
    }

    var stringValue: String {
            return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if container.decodeNil() {
                    return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if let value = try? container.decodeNil() {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                    return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                    let value = try decode(from: &container)
                    arr.append(value)
            }
            return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                    let value = try decode(from: &container, forKey: key)
                    dict[key.stringValue] = value
            }
            return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                    if let value = value as? Bool {
                            try container.encode(value)
                    } else if let value = value as? Int64 {
                            try container.encode(value)
                    } else if let value = value as? Double {
                            try container.encode(value)
                    } else if let value = value as? String {
                            try container.encode(value)
                    } else if value is JSONNull {
                            try container.encodeNil()
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer()
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                    let key = JSONCodingKey(stringValue: key)!
                    if let value = value as? Bool {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Int64 {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Double {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? String {
                            try container.encode(value, forKey: key)
                    } else if value is JSONNull {
                            try container.encodeNil(forKey: key)
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer(forKey: key)
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                    try container.encode(value)
            } else if let value = value as? Int64 {
                    try container.encode(value)
            } else if let value = value as? Double {
                    try container.encode(value)
            } else if let value = value as? String {
                    try container.encode(value)
            } else if value is JSONNull {
                    try container.encodeNil()
            } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
            }
    }

    public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                    self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                    self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                    let container = try decoder.singleValueContainer()
                    self.value = try JSONAny.decode(from: container)
            }
    }

    public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                    var container = encoder.unkeyedContainer()
                    try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                    var container = encoder.container(keyedBy: JSONCodingKey.self)
                    try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                    var container = encoder.singleValueContainer()
                    try JSONAny.encode(to: &container, value: self.value)
            }
    }
}







