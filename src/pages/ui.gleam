import gleam/list
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event
import model

pub fn get_pages() -> List(model.Page) {
  [model.Home, model.Projects, model.Blog]
}

pub fn get_title(page: model.Page) -> String {
  case page {
    model.Home -> ""
    model.Projects -> "Projects"
    model.Blog -> "Blog"
  }
}

/// Page shell shared by every route. Each section gets its own framed band,
/// and an empty band stretches to push the footer to the bottom.
pub fn layout(
  current_page: model.Page,
  sections: List(element.Element(model.Msg)),
) -> element.Element(model.Msg) {
  html.div([attribute.class("flex flex-col min-h-dvh")], [
    html.header([], [
      framed(True, [
        html.div([attribute.class("flex justify-between p-3")], [
          render_navbar(current_page),
        ]),
      ]),
    ]),
    html.main([], sections |> list.map(fn(section) { framed(True, [section]) })),
    html.div(
      [
        attribute.class("container mx-auto border-x-1 colored-border flex-1"),
      ],
      [],
    ),
    framed(False, [
      html.footer([attribute.class("p-3 text-center colored-border")], [
        html.p([attribute.class("text-sm opacity-50")], [
          html.text("© 2026 Alessandro Marcantoni. All rights reserved."),
        ]),
      ]),
    ]),
  ])
}

pub fn render_navbar(current_page: model.Page) -> element.Element(model.Msg) {
  html.nav(
    [
      attribute.class("flex justify-end"),
    ],
    get_pages()
      |> list.map(fn(page) {
        html.a(
          [
            attribute.href("#"),
            event.on_click(model.GoToPage(page)),
            attribute.class(case current_page == page {
              True -> "font-mono p-3 font-extrabold border-b-3 colored-border"
              False -> "font-mono p-3"
            }),
          ],
          [
            html.text("/" |> string.append(get_title(page) |> string.lowercase)),
          ],
        )
      }),
  )
}

pub fn framed(
  bottom_border: Bool,
  elements: List(element.Element(model.Msg)),
) -> element.Element(model.Msg) {
  html.div(
    [
      attribute.class(case bottom_border {
        True -> "border-b-1 colored-border"
        False -> "border-t-1 colored-border"
      }),
    ],
    [
      html.div(
        [
          attribute.class("container mx-auto border-x-1 colored-border"),
        ],
        elements,
      ),
    ],
  )
}

pub fn tagged(
  tag_name: String,
  elements: List(element.Element(model.Msg)),
) -> element.Element(model.Msg) {
  html.div([], [
    html.h2([attribute.class("text-lg font-mono text-muted opacity-50")], [
      html.text("<" |> string.append(tag_name) |> string.append(">")),
    ]),
    html.div([], elements),
    html.p([attribute.class("text-lg font-mono text-muted opacity-50")], [
      html.text("</" |> string.append(tag_name) |> string.append(">")),
    ]),
  ])
}

pub fn bullets(lines: List(String)) -> element.Element(model.Msg) {
  html.ul(
    [attribute.class("list-disc pl-6 space-y-1 font-mono")],
    lines |> list.map(fn(line) { html.li([], [html.text(line)]) }),
  )
}

pub fn skill_tags(skills: List(String)) -> element.Element(model.Msg) {
  html.ul(
    [attribute.class("flex flex-wrap gap-2 pt-2")],
    skills
      |> list.map(fn(skill) {
        html.li(
          [
            attribute.class(
              "font-mono text-sm px-2 py-0.5 border-1 colored-border",
            ),
          ],
          [html.text(skill)],
        )
      }),
  )
}
