import gleam/uri.{type Uri}
import lustre
import lustre/effect.{type Effect}
import lustre/element
import model.{type Model, type Msg, Blog, GoToPage, Home, Model, Projects}
import modem
import pages/blog
import pages/home
import pages/projects

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
  #(
    Model(profile: model.profile, current_page: page),
    modem.init(on_url_change),
  )
}

fn on_url_change(uri: Uri) -> Msg {
  GoToPage(model.page_from_path(uri.path))
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    GoToPage(page) -> #(Model(model.profile, current_page: page), effect.none())
  }
}

fn view(model: Model) -> element.Element(Msg) {
  case model.current_page {
    Home -> home.render_home(model)
    Projects -> projects.render_projects(model)
    Blog -> blog.render_blog(model)
  }
}
