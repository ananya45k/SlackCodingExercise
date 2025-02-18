import Foundation

protocol AutocompleteViewModelDelegate: AnyObject {
    func usersDataUpdated()
}

// MARK: - Interfaces
protocol AutocompleteViewModelInterface {
    /*
     * Fetches users from that match a given a search term
     */
    func fetchUsers(_ searchTerm: String?, completionHandler: @escaping ([UserSearchResult]) -> Void)

    /*
     * Updates usernames according to given update string.
     */
    func updateSearchText(text: String?)

    /*
    * Returns a user at the given position.
    */
    func user(at index: Int) -> UserSearchResult

    /*
     * Returns the count of the current usernames array.
     */
    func usersCount() -> Int

    /*
     Delegate that allows to send data updates through callback.
 */
    var delegate: AutocompleteViewModelDelegate? { get set }
}

class AutocompleteViewModel: AutocompleteViewModelInterface {
    private let resultsDataProvider: UserSearchResultDataProviderInterface
    private var users: [UserSearchResult] = []
    private var denyList: [String]
    public weak var delegate: AutocompleteViewModelDelegate?

    init(dataProvider: UserSearchResultDataProviderInterface) {
        self.resultsDataProvider = dataProvider
        denyList = AutocompleteViewModel.loadDenyList() ?? []
    }

    func updateSearchText(text: String?) {
        guard let input = text else {
            return
        }
        if !isStringDenied(input: input) {
            self.fetchUsers(text) { [weak self] users in
                DispatchQueue.main.async {
                    self?.users = users
                    self?.delegate?.usersDataUpdated()
                }
            }
        } else {
            print("String is denied")
            DispatchQueue.main.async {
                self.users.removeAll()
                self.delegate?.usersDataUpdated()
            }
        }
    }

    func usersCount() -> Int {
        print(users.count)
        return users.count
    }

    func user(at index: Int) -> UserSearchResult {
        return users[index]
    }
    
    func fetchUsers(_ searchTerm: String?, completionHandler: @escaping ([UserSearchResult]) -> Void) {
        guard let term = searchTerm, !term.isEmpty else {
            completionHandler([])
            return
        }

        self.resultsDataProvider.fetchUsers(term) { users in
            print(users)
            completionHandler(users)
        }
    }

    func isStringDenied(input: String) -> Bool {
        // Check if the input string matches any entry in the denylist
        return denyList.contains(input.lowercased())
    }
    
    static func loadDenyList() -> [String]? {
        // Get the path for the denylist.txt file in the app's bundle or file system
        guard let filePath = Bundle.main.path(forResource: "denylist", ofType: "txt") else {
            print("Denylist file not found.")
            return nil
        }
        
        do {
            // Read the content of the denylist file
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            // Split the contents by new lines and return the resulting array
            return fileContents.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        } catch {
            print("Failed to read denylist file: \(error)")
            return nil
        }
    }
}
