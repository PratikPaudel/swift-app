// Other/Extensions.swift
import Foundation

extension Encodable {
    func asDictionary() -> [String: Any] {
        var dictionary: [String: Any]?
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self) // Try encoding
            print("Encoded data for asDictionary: \(data)") // DEBUG

            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            dictionary = jsonObject as? [String: Any]
            if dictionary == nil {
                print("Failed to cast JSON object to [String: Any]. Object was: \(jsonObject)") // DEBUG
            }
        } catch {
            print("Error in asDictionary(): \(error.localizedDescription)") // DEBUG: Print the actual error
            print("Error details: \(error)") // DEBUG: Print full error
        }
        return dictionary ?? [:] // Return the dictionary or an empty one if nil
    }
}
