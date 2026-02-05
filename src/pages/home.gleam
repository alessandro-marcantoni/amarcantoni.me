import gleam/list
import lustre/attribute
import lustre/element
import lustre/element/html
import model
import pages/ui

pub fn render_home(model: model.Model) -> element.Element(model.Msg) {
  html.div([attribute.class("flex flex-col min-h-dvh h-dvh")], [
    render_header(model),
    ui.framed(True, [
      html.div(
        [
          attribute.class(
            "md:flex md:justify-between items-center border-b-1 colored-border",
          ),
        ],
        [
          html.div([attribute.class("py-6 pl-3")], [
            render_full_name(model.profile),
          ]),
          html.div(
            [
              attribute.class(
                "md:border-l-1 colored-border py-6 px-6 flex justify-center md:justify-end",
              ),
            ],
            [
              html.img([
                attribute.class("h-50 w-50 rounded-full"),
                attribute.src("imgs/profile.jpg"),
                attribute.alt("Avatar"),
              ]),
            ],
          ),
        ],
      ),
      html.section([attribute.class("p-3")], [
        ui.tagged("about", [
          html.div(
            [attribute.class("space-y-3")],
            model.profile.about
              |> list.map(fn(line) {
                html.p([attribute.class("font-mono text-lg")], [
                  html.text(line),
                ])
              }),
          ),
        ]),
      ]),
    ]),
    ui.framed(True, [render_contact_info(model.profile)]),
    html.div(
      [
        attribute.class("container mx-auto border-x-1 colored-border flex-1"),
      ],
      [],
    ),
    ui.framed(False, [
      html.footer([attribute.class("p-3 text-center colored-border")], [
        html.p([attribute.class("text-sm opacity-50")], [
          html.text("© 2026 Alessandro Marcantoni. All rights reserved."),
        ]),
      ]),
    ]),
  ])
}

fn render_header(model: model.Model) -> element.Element(model.Msg) {
  html.header([], [
    ui.framed(True, [
      html.div([attribute.class("flex justify-between p-3")], [
        ui.render_navbar(model.current_page),
      ]),
    ]),
  ])
}

fn render_full_name(profile: model.Profile) -> element.Element(model.Msg) {
  html.div([], [
    ui.tagged("name", [
      html.h1(
        [
          attribute.class("font-mono text-2xl md:text-4xl typewriter"),
        ],
        [
          html.span([], [
            html.text(profile.first_name <> " " <> profile.last_name),
          ]),
        ],
      ),
    ]),
  ])
}

fn render_contact_info(profile: model.Profile) -> element.Element(model.Msg) {
  html.div([attribute.class("p-3")], [
    ui.tagged("contact", [
      html.ul(
        [attribute.class("space-y-2")],
        profile.contact_info
          |> list.map(fn(info) {
            html.li([], [
              html.span([attribute.class("flex gap-3")], [
                html.p(
                  [
                    attribute.class("font-mono text-md"),
                  ],
                  [
                    html.text(info.label <> ":"),
                  ],
                ),
                html.a(
                  [
                    attribute.href(info.url),
                    attribute.class("font-mono text-md underline"),
                    attribute.target("_blank"),
                  ],
                  [
                    html.text(info.display),
                  ],
                ),
              ]),
            ])
          }),
      ),
    ]),
  ])
}
