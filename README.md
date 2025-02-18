# SlackCodingExercise

Since the project template is based on UIKit and ViewControllers, I implemented a custom UserTableViewCell instead of using SwiftUIView with UIHostingController.

- Refactored AutocompleteViewModelInterface to return UserSearchResult instead of username strings, updating related functions accordingly.
- Extended UserSearchResult to include imageUrl, displayName , and id for better response parsing.
