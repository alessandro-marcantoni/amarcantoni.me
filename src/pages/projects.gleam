import gleam/int
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html
import model
import pages/ui

pub fn render_projects(model: model.Model) -> element.Element(model.Msg) {
  ui.layout(
    model.current_page,
    model.profile.projects |> list.index_map(render_project),
  )
}

fn render_project(
  project: model.Project,
  index: Int,
) -> element.Element(model.Msg) {
  let number = string.pad_start(int.to_string(index + 1), to: 2, with: "0")
  ui.section("project", [
    html.article([attribute.class("md:flex gap-10")], [
      html.p(
        [
          attribute.class(
            "text-5xl md:text-6xl font-extrabold text-accent/25 leading-none pb-4 md:pb-0",
          ),
        ],
        [html.text(number)],
      ),
      html.div([attribute.class("flex-1")], [
        html.h2([attribute.class("text-2xl md:text-3xl font-bold")], [
          html.text(project.name),
        ]),
        html.p([attribute.class("pt-1 pb-5 text-accent")], [
          html.text(project.tagline),
        ]),
        ui.bullets(project.highlights),
        ui.skill_tags(project.skills),
      ]),
    ]),
  ])
}
