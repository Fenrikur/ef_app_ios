//
//  Link.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import EVReflection

@objcMembers
class LinkFragment: EVObject, VersionedDataModel {
	class var DataModelVersion: Int { return 2 }

	enum LinkFragmentType: String, EVRaw {
		case DealerDetail
		case EventConferenceRoom
		case MapEntry
		case MapExternal
		case WebExternal
	}

	var FragmentType: LinkFragmentType = LinkFragmentType.WebExternal
	var Name: String = ""
	var Target: String = ""

	weak var TargetObject: AnyObject?

	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "TargetObject", keyInResource: nil)]
	}

	override func setValue(_ value: Any!, forUndefinedKey key: String) {
		switch key {
		case "FragmentType":
			if let rawValue = value as? String {
				if let status =  LinkFragmentType(rawValue: rawValue) {
					self.FragmentType = status
				}
			}
		default:
			self.addStatusMessage(.IncorrectKey, message: "SetValue for key '\(key)' should be handled.")
			print("---> setValue for key '\(key)' should be handled.")
		}
	}
}

extension LinkFragment {
	func getTarget<T>() -> T? {
		switch FragmentType {
		case .WebExternal:
			return URL(string: Target) as? T
		default:
			return TargetObject as? T
		}
	}
}
