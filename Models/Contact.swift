import Foundation

struct Contact: Identifiable, Hashable, Codable{
    var id = UUID()
    var name: String
    var surname: String
    var phoneNumber: String
    var email: String
    var group: DisclosureGroups
    var imageName: String?
}

enum DisclosureGroups: String, CaseIterable, Codable{
        case doctors = "👨🏻‍⚕️ Doctors 👨🏻‍⚕️"
        case pharmacies = "🏥 Pharmacies 🏥"
        case caregivers = "🧑‍🧒 Caregivers 🧑‍🧒"
    }

