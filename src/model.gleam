import content.{type Profile}
import theme.{type Theme}

pub type Model {
  Model(profile: Profile, current_page: Page, theme: Theme)
}

pub type Msg {
  GoToPage(Page)
  /// Carries the theme id from the switcher's <select>.
  ChangeTheme(String)
}

pub type Page {
  Home
  Projects
  Blog
}

pub fn page_path(page: Page) -> String {
  case page {
    Home -> "/"
    Projects -> "/projects"
    Blog -> "/blog"
  }
}

/// Unknown paths fall back to the home page instead of a 404.
pub fn page_from_path(path: String) -> Page {
  case path {
    "/projects" | "/projects/" -> Projects
    "/blog" | "/blog/" -> Blog
    _ -> Home
  }
}
