import gleam/list
import gleam/result

pub type Theme {
  Theme(id: String, label: String)
}

/// The first theme is the default. Each id other than the default needs a
/// matching `:root[data-theme="..."]` block in portfolio.css.
pub const all = [
  Theme("default", "Default"),
  Theme("one-dark", "One Dark"),
  Theme("dracula", "Dracula"),
  Theme("monokai", "Monokai"),
  Theme("nord", "Nord"),
  Theme("github-light", "GitHub Light"),
  Theme("solarized-light", "Solarized Light"),
]

pub const default = Theme("default", "Default")

/// Unknown ids, such as one saved by an older version of the site, fall back
/// to the default.
pub fn from_id(id: String) -> Theme {
  all
  |> list.find(fn(theme) { theme.id == id })
  |> result.unwrap(default)
}

/// The theme that the inline script in gleam.toml applied before first paint.
pub fn current() -> Theme {
  from_id(do_current())
}

/// Applies the theme to the page and saves it for the next visit.
pub fn apply(theme: Theme) -> Nil {
  do_apply(theme.id)
}

@external(javascript, "./theme_ffi.mjs", "current")
fn do_current() -> String

@external(javascript, "./theme_ffi.mjs", "apply")
fn do_apply(id: String) -> Nil
