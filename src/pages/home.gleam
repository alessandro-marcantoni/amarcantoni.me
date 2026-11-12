import gleam/list
import lustre/attribute
import lustre/element
import lustre/element/html
import model
import pages/ui

pub fn render_home(model: model.Model) -> element.Element(model.Msg) {
  let profile = model.profile
  ui.layout(model.current_page, [
    html.div([], [
      html.div(
        [
          attribute.class(
            "md:flex md:justify-between items-center border-b-1 colored-border",
          ),
        ],
        [
          html.div([attribute.class("py-6 pl-3")], [
            render_full_name(profile),
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
            profile.about
              |> list.map(fn(line) {
                html.p([attribute.class("font-mono text-lg")], [
                  html.text(line),
                ])
              }),
          ),
        ]),
      ]),
    ]),
    render_contact_info(profile),
    render_experience(profile.experience),
    render_education(profile.education),
    render_languages(profile.languages),
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
    html.p([attribute.class("font-mono pt-3 opacity-75")], [
      html.text(profile.location),
    ]),
  ])
}

fn render_contact_info(profile: model.Profile) -> element.Element(model.Msg) {
  html.section([attribute.class("p-3")], [
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

fn render_experience(
  experience: List(model.Experience),
) -> element.Element(model.Msg) {
  html.section([attribute.class("p-3")], [
    ui.tagged("experience", [
      html.div(
        [attribute.class("space-y-8 py-3")],
        experience
          |> list.map(fn(job) {
            html.article([attribute.class("space-y-2")], [
              html.h3([attribute.class("font-mono text-lg font-bold")], [
                html.text(job.role <> " @ " <> job.company),
              ]),
              html.p([attribute.class("font-mono text-sm opacity-50")], [
                html.text(job.period <> " · " <> job.location),
              ]),
              ui.bullets(job.highlights),
              ui.skill_tags(job.skills),
            ])
          }),
      ),
    ]),
  ])
}

fn render_education(
  education: List(model.Education),
) -> element.Element(model.Msg) {
  html.section([attribute.class("p-3")], [
    ui.tagged("education", [
      html.ul(
        [attribute.class("space-y-3 py-3")],
        education
          |> list.map(fn(entry) {
            html.li([attribute.class("font-mono")], [
              html.p([attribute.class("font-bold")], [html.text(entry.degree)]),
              html.p([attribute.class("text-sm opacity-50")], [
                html.text(entry.school <> " · " <> entry.grade),
              ]),
            ])
          }),
      ),
    ]),
  ])
}

fn render_languages(
  languages: List(model.Language),
) -> element.Element(model.Msg) {
  html.section([attribute.class("p-3")], [
    ui.tagged("languages", [
      html.ul(
        [attribute.class("space-y-1 py-3")],
        languages
          |> list.map(fn(language) {
            html.li([attribute.class("font-mono")], [
              html.text(language.name <> ": " <> language.level),
            ])
          }),
      ),
    ]),
  ])
}
