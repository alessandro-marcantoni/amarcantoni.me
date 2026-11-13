import gleam/list
import gleam/string
import gleeunit
import model
import simplifile
import theme

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn page_path_round_trips_test() {
  [model.Home, model.Projects, model.Blog]
  |> list.each(fn(page) {
    assert model.page_from_path(model.page_path(page)) == page
  })
}

pub fn page_from_path_accepts_trailing_slash_test() {
  assert model.page_from_path("/projects/") == model.Projects
  assert model.page_from_path("/blog/") == model.Blog
}

pub fn unknown_path_falls_back_to_home_test() {
  assert model.page_from_path("/nope") == model.Home
  assert model.page_from_path("") == model.Home
}

pub fn theme_from_id_finds_each_theme_test() {
  theme.all
  |> list.each(fn(t) {
    assert theme.from_id(t.id) == t
  })
}

pub fn unknown_theme_falls_back_to_default_test() {
  assert theme.from_id("solarized-dark") == theme.default
}

pub fn default_theme_is_first_test() {
  assert list.first(theme.all) == Ok(theme.default)
}

/// A theme without a CSS block would silently render as the default.
pub fn every_theme_has_a_css_block_test() {
  let assert Ok(css) = simplifile.read("src/portfolio.css")
  theme.all
  |> list.filter(fn(t) { t != theme.default })
  |> list.each(fn(t) {
    assert string.contains(css, ":root[data-theme=\"" <> t.id <> "\"]")
  })
}
