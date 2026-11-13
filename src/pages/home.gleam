import content
import gleam/int
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html
import model
import pages/ui

pub fn render_home(model: model.Model) -> element.Element(model.Msg) {
  let profile = model.profile
  ui.layout(model, [
    render_hero(profile),
    render_stats(profile.stats),
    ui.section("about", [
      html.div(
        [attribute.class("space-y-4 max-w-3xl")],
        profile.about
          |> list.map(fn(line) {
            html.p([attribute.class("text-base md:text-lg leading-relaxed")], [
              html.text(line),
            ])
          }),
      ),
    ]),
    render_contact_info(profile.contact_info),
    render_experience(profile.experience),
    render_background(profile.education, profile.languages),
    render_extras(profile.certifications, profile.volunteering),
  ])
}

fn render_hero(profile: content.Profile) -> element.Element(model.Msg) {
  let name = profile.first_name <> " " <> profile.last_name
  html.div(
    [
      attribute.class(
        "flex flex-col-reverse md:flex-row md:items-center md:justify-between gap-8 p-6 md:p-10",
      ),
    ],
    [
      ui.tagged("name", [
        html.h1(
          [
            attribute.class(
              "text-2xl sm:text-4xl md:text-5xl font-extrabold typewriter",
            ),
            // The typing animation reveals one character per step.
            attribute.style("--chars", int.to_string(string.length(name))),
          ],
          [html.text(name)],
        ),
        html.p([attribute.class("pt-4 text-lg md:text-xl text-accent")], [
          html.text(profile.role),
        ]),
        html.p([attribute.class("pt-1 text-sm text-muted")], [
          html.text("based in " <> profile.location),
        ]),
        html.a(
          [
            attribute.href("/alessandro-marcantoni-cv.pdf"),
            attribute.download(""),
            attribute.class(
              "mt-6 inline-flex items-center gap-2 rounded-md border border-accent/60 px-4 py-2 text-sm text-accent hover:bg-accent hover:text-bg transition-colors",
            ),
          ],
          [
            html.span([attribute.aria_hidden(True)], [html.text("↓")]),
            html.text("Download CV"),
          ],
        ),
      ]),
      html.div([attribute.class("flex justify-center md:justify-end")], [
        html.img([
          attribute.class(
            "size-36 md:size-48 rounded-full object-cover ring-2 ring-accent/50 ring-offset-4 ring-offset-bg shadow-[0_0_80px_-12px] shadow-accent/50",
          ),
          attribute.src("/imgs/profile.webp"),
          attribute.alt("Portrait of " <> profile.first_name),
        ]),
      ]),
    ],
  )
}

fn render_stats(stats: List(content.Stat)) -> element.Element(model.Msg) {
  // gap-px over a line-colored background draws the grid lines between cells.
  html.dl(
    [attribute.class("grid grid-cols-2 md:grid-cols-4 gap-px bg-line")],
    stats
      |> list.map(fn(stat) {
        html.div([attribute.class("bg-bg px-6 py-5 md:px-10")], [
          html.dt([attribute.class("sr-only")], [html.text(stat.label)]),
          html.dd(
            [attribute.class("text-2xl md:text-3xl font-bold text-accent")],
            [html.text(stat.value)],
          ),
          html.dd([attribute.class("pt-1 text-xs text-muted")], [
            html.text(stat.label),
          ]),
        ])
      }),
  )
}

fn render_contact_info(
  contact_info: List(content.ContactInfo),
) -> element.Element(model.Msg) {
  ui.section("contact", [
    html.ul(
      [attribute.class("grid sm:grid-cols-3 gap-3")],
      contact_info
        |> list.map(fn(info) {
          html.li([], [
            ui.link_card(url: info.url, eyebrow: info.label, body: [
              html.span(
                [
                  attribute.class(
                    "text-sm break-all group-hover:text-accent transition-colors",
                  ),
                ],
                [html.text(info.display)],
              ),
            ]),
          ])
        }),
    ),
  ])
}

fn render_experience(
  experience: List(content.Experience),
) -> element.Element(model.Msg) {
  ui.section("experience", [
    html.ol(
      [attribute.class("relative ml-1 border-l border-line space-y-12")],
      experience
        |> list.map(fn(job) {
          html.li([attribute.class("relative pl-6 md:pl-8")], [
            html.span(
              [
                attribute.class(
                  "absolute -left-[5px] top-1.5 size-2.5 rounded-full bg-accent ring-4 ring-bg",
                ),
              ],
              [],
            ),
            ui.role_entry(job),
          ])
        }),
    ),
  ])
}

fn render_background(
  education: List(content.Education),
  languages: List(content.Language),
) -> element.Element(model.Msg) {
  two_columns([
    ui.section("education", [
      html.ul(
        [attribute.class("space-y-5")],
        education
          |> list.map(fn(entry) {
            html.li([], [
              html.p(
                [
                  attribute.class(
                    "pb-1 text-xs uppercase tracking-wider text-accent",
                  ),
                ],
                [html.text(entry.period)],
              ),
              html.p([attribute.class("font-bold")], [html.text(entry.degree)]),
              html.p([attribute.class("pt-1 text-sm text-muted")], [
                html.text(entry.school),
              ]),
              html.p([attribute.class("pt-1 text-sm text-accent")], [
                html.text(entry.grade),
              ]),
            ])
          }),
      ),
    ]),
    ui.section("languages", [
      html.ul(
        [attribute.class("space-y-3")],
        languages
          |> list.map(fn(language) {
            html.li([attribute.class("flex justify-between max-w-xs")], [
              html.span([], [html.text(language.name)]),
              html.span([attribute.class("text-accent")], [
                html.text(language.level),
              ]),
            ])
          }),
      ),
    ]),
  ])
}

fn render_extras(
  certifications: List(content.Certification),
  volunteering: List(content.Experience),
) -> element.Element(model.Msg) {
  two_columns([
    ui.section("certifications", [
      html.ul(
        [attribute.class("space-y-3")],
        certifications
          |> list.map(fn(cert) {
            html.li([], [
              ui.link_card(url: cert.url, eyebrow: cert.issuer, body: [
                html.span(
                  [
                    attribute.class(
                      "pt-1 font-bold group-hover:text-accent transition-colors",
                    ),
                  ],
                  [html.text(cert.name)],
                ),
                html.span([attribute.class("text-sm text-muted")], [
                  html.text(cert.period),
                ]),
              ]),
            ])
          }),
      ),
    ]),
    ui.section("volunteering", [
      html.ul(
        [attribute.class("space-y-6")],
        volunteering
          |> list.map(fn(role) { html.li([], [ui.role_entry(role)]) }),
      ),
    ]),
  ])
}

/// Side by side from md up, stacked with a divider below that.
fn two_columns(
  columns: List(element.Element(model.Msg)),
) -> element.Element(model.Msg) {
  html.div(
    [
      attribute.class(
        "grid md:grid-cols-2 divide-y md:divide-y-0 md:divide-x divide-line",
      ),
    ],
    columns,
  )
}
