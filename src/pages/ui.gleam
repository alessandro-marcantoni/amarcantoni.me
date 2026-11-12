import gleam/bool
import gleam/int
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html
import model

/// Pages listed in the navbar. Blog stays reachable at /blog but is left out
/// until it has a post.
pub fn get_pages() -> List(model.Page) {
  [model.Home, model.Projects]
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
    html.header(
      [attribute.class("sticky top-0 z-10 bg-bg/80 backdrop-blur-md")],
      [
        framed(True, [
          html.div([attribute.class("flex items-center justify-between px-3")], [
            html.a(
              [
                attribute.href(model.page_path(model.Home)),
                attribute.class(
                  "py-4 px-3 text-sm font-bold tracking-tight hover:text-accent transition-colors",
                ),
              ],
              [
                html.span([attribute.class("text-accent")], [html.text("~/")]),
                html.text("alessandro"),
              ],
            ),
            render_navbar(current_page),
          ]),
        ]),
      ],
    ),
    html.main(
      [],
      sections
        |> list.index_map(fn(section, index) {
          framed(True, [
            html.div(
              [
                attribute.class("rise"),
                attribute.style(
                  "animation-delay",
                  int.to_string(index * 80) <> "ms",
                ),
              ],
              [section],
            ),
          ])
        }),
    ),
    html.div(
      [attribute.class("container mx-auto border-x border-line flex-1")],
      [],
    ),
    framed(False, [
      html.footer(
        [
          attribute.class(
            "px-6 py-5 flex flex-col sm:flex-row gap-2 justify-between text-xs text-muted",
          ),
        ],
        [
          html.p([], [
            html.text("© 2026 Alessandro Marcantoni. All rights reserved."),
          ]),
          html.p([], [
            html.text("Built with "),
            html.a(
              [
                attribute.href("https://gleam.run"),
                attribute.target("_blank"),
                attribute.class("text-accent hover:underline"),
              ],
              [html.text("Gleam")],
            ),
            html.text(" and "),
            html.a(
              [
                attribute.href("https://hexdocs.pm/lustre"),
                attribute.target("_blank"),
                attribute.class("text-accent hover:underline"),
              ],
              [html.text("Lustre")],
            ),
          ]),
        ],
      ),
    ]),
  ])
}

pub fn render_navbar(current_page: model.Page) -> element.Element(model.Msg) {
  html.nav(
    [attribute.class("flex")],
    get_pages()
      |> list.map(fn(page) {
        let is_current = current_page == page
        html.a(
          [
            attribute.href(model.page_path(page)),
            case is_current {
              True -> attribute.aria_current("page")
              False -> attribute.none()
            },
            attribute.class(case is_current {
              True ->
                "px-3 py-4 text-sm text-accent font-bold border-b-2 border-accent"
              False ->
                "px-3 py-4 text-sm text-muted border-b-2 border-transparent hover:text-fg transition-colors"
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
        True -> "border-b border-line"
        False -> "border-t border-line"
      }),
    ],
    [
      html.div(
        [attribute.class("container mx-auto border-x border-line")],
        elements,
      ),
    ],
  )
}

/// Wraps content in an opening and closing pseudo-HTML tag, colored like
/// code in an editor.
pub fn tagged(
  tag_name: String,
  elements: List(element.Element(model.Msg)),
) -> element.Element(model.Msg) {
  html.div([], [
    html.h2([attribute.class("text-sm")], tag(tag_name, False)),
    html.div([attribute.class("py-5 pl-4 md:pl-6")], elements),
    html.p([attribute.class("text-sm")], tag(tag_name, True)),
  ])
}

fn tag(name: String, closing: Bool) -> List(element.Element(model.Msg)) {
  let open = case closing {
    True -> "</"
    False -> "<"
  }
  [
    html.span([attribute.class("text-muted/60")], [html.text(open)]),
    html.span([attribute.class("text-accent/80")], [html.text(name)]),
    html.span([attribute.class("text-muted/60")], [html.text(">")]),
  ]
}

pub fn section(
  tag_name: String,
  elements: List(element.Element(model.Msg)),
) -> element.Element(model.Msg) {
  html.section([attribute.class("p-6 md:p-10")], [tagged(tag_name, elements)])
}

pub fn bullets(lines: List(String)) -> element.Element(model.Msg) {
  html.ul(
    [
      attribute.class(
        "max-w-3xl space-y-2 text-sm md:text-[0.95rem] leading-relaxed",
      ),
    ],
    lines
      |> list.map(fn(line) {
        html.li([attribute.class("flex gap-3")], [
          html.span([attribute.class("text-accent shrink-0 select-none")], [
            html.text("▹"),
          ]),
          html.span([attribute.class("text-fg/85")], [html.text(line)]),
        ])
      }),
  )
}

pub fn skill_tags(skills: List(String)) -> element.Element(model.Msg) {
  use <- bool.guard(when: list.is_empty(skills), return: element.none())
  html.ul(
    [attribute.class("flex flex-wrap gap-2 pt-4")],
    skills
      |> list.map(fn(skill) {
        html.li(
          [
            attribute.class(
              "text-xs px-2.5 py-1 rounded-md border border-line bg-highlight/40 text-muted hover:text-accent hover:border-accent/50 transition-colors",
            ),
          ],
          [html.text(skill)],
        )
      }),
  )
}

/// The ↗ marker for links that open in a new tab, with the same warning in
/// text for screen readers.
pub fn external_arrow() -> element.Element(model.Msg) {
  element.fragment([
    html.span(
      [
        attribute.class(
          "group-hover:text-accent group-hover:translate-x-0.5 group-hover:-translate-y-0.5 transition-transform",
        ),
        attribute.aria_hidden(True),
      ],
      [html.text("↗")],
    ),
    html.span([attribute.class("sr-only")], [html.text("(opens in a new tab)")]),
  ])
}
