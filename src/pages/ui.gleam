import content
import gleam/bool
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event
import model
import theme

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
  model: model.Model,
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
            html.div([attribute.class("flex items-center")], [
              render_navbar(model.current_page),
              render_theme_switcher(model.theme),
            ]),
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

/// A native <select> stretched invisibly over a compact label, so phones get
/// their own picker and the header stays narrow.
fn render_theme_switcher(current: theme.Theme) -> element.Element(model.Msg) {
  html.label(
    [
      attribute.class(
        "relative flex items-center gap-1.5 px-3 py-4 text-sm text-muted hover:text-fg focus-within:text-accent transition-colors cursor-pointer",
      ),
    ],
    [
      html.span([attribute.aria_hidden(True)], [html.text("◐")]),
      html.span([attribute.class("hidden sm:inline")], [
        html.text(current.label),
      ]),
      html.select(
        [
          attribute.class("absolute inset-0 opacity-0 cursor-pointer"),
          attribute.aria_label("Color theme"),
          event.on_change(model.ChangeTheme),
        ],
        theme.all
          |> list.map(fn(option) {
            html.option(
              [
                attribute.value(option.id),
                attribute.selected(option.id == current.id),
              ],
              option.label,
            )
          }),
      ),
    ],
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
    html.span([attribute.class("text-tag/80")], [html.text(name)]),
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
          "inline-block group-hover:text-accent group-hover:translate-x-0.5 group-hover:-translate-y-0.5 transition-transform",
        ),
        attribute.aria_hidden(True),
      ],
      [html.text("↗")],
    ),
    html.span([attribute.class("sr-only")], [html.text("(opens in a new tab)")]),
  ])
}

/// A bordered card that links out in a new tab. The eyebrow row carries the
/// small label and the ↗ marker; `body` is the rest of the card.
pub fn link_card(
  url url: String,
  eyebrow eyebrow: String,
  body body: List(element.Element(model.Msg)),
) -> element.Element(model.Msg) {
  html.a(
    [
      attribute.href(url),
      attribute.target("_blank"),
      attribute.rel("noopener"),
      attribute.class(
        "group flex h-full flex-col gap-1 rounded-lg border border-line p-4 hover:border-accent/60 hover:bg-highlight/40 transition-colors",
      ),
    ],
    [
      html.span(
        [
          attribute.class(
            "flex justify-between text-xs uppercase tracking-wider text-muted",
          ),
        ],
        [html.text(eyebrow), external_arrow()],
      ),
      ..body
    ],
  )
}

/// One job or volunteering role: period, title, optional location, then the
/// highlights and skills.
pub fn role_entry(role: content.Experience) -> element.Element(model.Msg) {
  html.div([], [
    html.p([attribute.class("text-xs uppercase tracking-wider text-accent")], [
      html.text(role.period),
    ]),
    html.h3([attribute.class("pt-2 text-lg md:text-xl font-bold")], [
      html.text(role.role),
      html.span([attribute.class("text-muted font-normal")], [
        html.text(" @ "),
      ]),
      html.span([attribute.class("text-accent")], [html.text(role.company)]),
    ]),
    case role.location {
      Some(location) ->
        html.p([attribute.class("pt-1 text-sm text-muted")], [
          html.text(location),
        ])
      None -> element.none()
    },
    html.div([attribute.class("pt-4")], [
      bullets(role.highlights),
      skill_tags(role.skills),
    ]),
  ])
}
