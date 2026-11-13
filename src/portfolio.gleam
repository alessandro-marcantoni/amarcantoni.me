import content
import gleam/uri.{type Uri}
import lustre
import lustre/effect.{type Effect}
import lustre/element
import model.{
  type Model, type Msg, Blog, ChangeTheme, GoToPage, Home, Model, Projects,
}
import modem
import pages/blog
import pages/home
import pages/projects
import theme

pub fn main() -> Nil {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn init(_args) -> #(Model, Effect(Msg)) {
  let page = case modem.initial_uri() {
    Ok(uri) -> model.page_from_path(uri.path)
    Error(_) -> Home
  }
  let theme = theme.current()
  #(
    Model(profile: content.profile, current_page: page, theme:),
    effect.batch([modem.init(on_url_change), apply_theme(theme)]),
  )
}

fn on_url_change(uri: Uri) -> Msg {
  GoToPage(model.page_from_path(uri.path))
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    GoToPage(page) -> #(Model(..model, current_page: page), effect.none())
    ChangeTheme(id) -> {
      let theme = theme.from_id(id)
      #(Model(..model, theme:), apply_theme(theme))
    }
  }
}

fn view(model: Model) -> element.Element(Msg) {
  case model.current_page {
    Home -> home.render_home(model)
    Projects -> projects.render_projects(model)
    Blog -> blog.render_blog(model)
  }
}

fn apply_theme(theme: theme.Theme) -> Effect(Msg) {
  use _ <- effect.from
  theme.apply(theme)
}
