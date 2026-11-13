import lustre/attribute
import lustre/element
import lustre/element/html
import model
import pages/ui

pub fn render_blog(model: model.Model) -> element.Element(model.Msg) {
  ui.layout(model, [
    ui.section("blog", [
      html.p([attribute.class("text-sm text-muted")], [
        html.span([attribute.class("text-accent")], [html.text("$ ")]),
        html.text("ls posts/"),
      ]),
      html.p([attribute.class("pt-2 text-lg cursor")], [
        html.text("No posts yet. "),
      ]),
    ]),
  ])
}
