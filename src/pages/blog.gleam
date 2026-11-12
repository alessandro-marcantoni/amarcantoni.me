import lustre/attribute
import lustre/element
import lustre/element/html
import model
import pages/ui

pub fn render_blog(model: model.Model) -> element.Element(model.Msg) {
  ui.layout(model.current_page, [
    html.section([attribute.class("p-3")], [
      ui.tagged("blog", [
        html.p([attribute.class("font-mono text-lg py-3")], [
          html.text("No posts yet."),
        ]),
      ]),
    ]),
  ])
}
