import lustre
import lustre/element
import lustre/element/html
import model.{type Model, type Msg, Blog, GoToPage, Home, Model, Projects}
import pages/home

pub fn main() -> Nil {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn init(_args) -> model.Model {
  Model(profile: model.profile, current_page: Home)
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    GoToPage(page) -> Model(model.profile, current_page: page)
  }
}

fn view(model: Model) -> element.Element(Msg) {
  case model.current_page {
    Home -> home.render_home(model)
    Projects -> html.div([], [html.text("Projects Page")])
    Blog -> html.div([], [html.text("Blog Page")])
  }
}
