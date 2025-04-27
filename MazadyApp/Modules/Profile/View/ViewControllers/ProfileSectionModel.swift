//
//  ProfileSectionModel.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import RxDataSources

enum ProfileSectionModel {
    case productsSection(items: [Product])
    case adsSection(items: [Advertisement])
    case tagsSection(items: [Tag])
}

extension ProfileSectionModel: SectionModelType {
    typealias Item = Any

    var items: [Any] {
        switch self {
        case .productsSection(let items):
            return items
        case .adsSection(let items):
            return items
        case .tagsSection(let items):
            return items
        }
    }

    init(original: ProfileSectionModel, items: [Any]) {
        switch original {
        case .productsSection:
            self = .productsSection(items: items as! [Product])
        case .adsSection:
            self = .adsSection(items: items as! [Advertisement])
        case .tagsSection:
            self = .tagsSection(items: items as! [Tag])
        }
    }
}

