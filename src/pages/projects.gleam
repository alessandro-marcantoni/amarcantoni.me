import gleam/list
import lustre/attribute
import lustre/element
import lustre/element/html
import model
import pages/ui

pub fn render_projects(model: model.Model) -> element.Element(model.Msg) {
  ui.layout(
    model.current_page,
    model.profile.projects |> list.map(render_project),
  )
}

fn render_project(project: model.Project) -> element.Element(model.Msg) {
  html.section([attribute.class("p-3")], [
    ui.tagged("project", [
      html.article([attribute.class("space-y-2 py-3")], [
        html.h2([attribute.class("font-mono text-2xl font-bold")], [
          html.text(project.name),
        ]),
        html.p([attribute.class("font-mono opacity-75")], [
          html.text(project.tagline),
        ]),
        ui.bullets(project.highlights),
        ui.skill_tags(project.skills),
      ]),
    ]),
  ])
}
