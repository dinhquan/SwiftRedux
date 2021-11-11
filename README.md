# Redux + MVVM + Combine + SwiftUI
Demonstrate how to using Redux with MVVM pattern to make clean archirecture iOS project

## High level overview

![alt text](https://github.com/dinhquan/SwiftRedux/blob/main/Images/ReduxArchitecture.png)

## Usage

### Define AppState, AppAction

```swift
/// Hold all state of the app
struct AppState {
    var articles: [Article] = []
}

/// Action should be declared as a tree like this
enum AppAction {
    case article(ArticleAction)
}

enum ArticleAction {
    case fetchArticle(keyword: String, page: Int)
    case fetchArticleSuccess(articles: [Article])
    case fetchArticleFailure(error: Error)
}
```

### Define AppStore

```swift
/// Environment to contain all dependencies which will be used in reducers
struct Environment {
    @Injected var articleService: ArticleService
}

/// AppStore
typealias AppStore = Store<AppState, AppAction, Environment>
```

### Create Reducers

```swift
let articleReducer: Reducer<AppState, AppAction, Environment> = { state, action, env in
    guard case let .article(articleAction) = action else { return Empty().eraseToAnyPublisher() }
    switch articleAction {
    case let .fetchArticle(keyword, page):
        return env.articleService.searchArticlesByKeyword(keyword, page: page)
            .map { .article(.fetchArticleSuccess(articles: $0)) }
            .catch { Just(.article(.fetchArticleFailure(error: $0))).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case let .fetchArticleSuccess(articles):
        state.articles = articles
    case let .fetchArticleFailure(error):
        print("Failed to load article with error \(error.localizedDescription)")
    }
    return Empty().eraseToAnyPublisher()
}
```

### Communicating between Redux and ViewModel

```swift
final class ArticleListViewModel: ObservableObject {
    @ReduxStore var store: AppStore

    @Published private(set) var isLoading = false
    @Published private(set) var articles: [Article] = []
    
    func searchArticles(keyword: String) {
        store.dispatch(.article(.fetchArticle(keyword: keyword, page: 1)))
    }
    
    init() {
        store.$state.map(\.articles).assign(to: &$articles)
    }
}
```
