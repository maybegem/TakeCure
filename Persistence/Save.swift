import Foundation

func getDocumentsDirectory() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

func saveTasksToFile(tasks: [Task]) {
    let url = getDocumentsDirectory().appendingPathComponent("tasks.json")
    
    do {
        let data = try JSONEncoder().encode(tasks)
        try data.write(to: url, options: [.atomicWrite, .completeFileProtection])
        print("Tasks saved to \(url)")
    } catch {
        print("Error saving tasks: \(error.localizedDescription)")
    }
}

func loadTasksFromFile() -> [Task] {
    let url = getDocumentsDirectory().appendingPathComponent("tasks.json")
    
    do {
        let data = try Data(contentsOf: url)
        let tasks = try JSONDecoder().decode([Task].self, from: data)
        return tasks
    } catch {
        print("Error loading tasks: \(error.localizedDescription)")
        return []
    }
}


func saveContactsToFile(contacts: [Contact]) {
    let url = getDocumentsDirectory().appendingPathComponent("contacts.json")
    
    do {
        let data = try JSONEncoder().encode(contacts)
        try data.write(to: url, options: [.atomicWrite, .completeFileProtection])
        print("Contacts saved to \(url)")
    } catch {
        print("Error saving contacts: \(error.localizedDescription)")
    }
}

func loadContactsFromFile() -> [Contact] {
    let url = getDocumentsDirectory().appendingPathComponent("contacts.json")
    
    do {
        let data = try Data(contentsOf: url)
        let contacts = try JSONDecoder().decode([Contact].self, from: data)
        return contacts
    } catch {
        print("Error loading contacts: \(error.localizedDescription)")
        return []
    }
}



func saveIntroToFile(intro: Bool) {
    let url = getDocumentsDirectory().appendingPathComponent("intro.json")
    
    do {
        let data = try JSONEncoder().encode(intro)
        try data.write(to: url, options: [.atomicWrite, .completeFileProtection])
        print("intro saved to \(url)")
    } catch {
        print("Error saving intro: \(error.localizedDescription)")
    }
}


func loadIntroFromFile() -> Bool {
    let url = getDocumentsDirectory().appendingPathComponent("intro.json")
    
    do {
        let data = try Data(contentsOf: url)
        let intro = try JSONDecoder().decode(Bool.self, from: data)
        return intro
    } catch {
        print("Error loading intro: \(error.localizedDescription)")
        return true
    }
}
