import gleam/list
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html
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
