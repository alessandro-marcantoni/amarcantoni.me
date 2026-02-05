pub type Model {
  Model(profile: Profile, current_page: Page)
}

pub type Msg {
  GoToPage(Page)
}

pub type Page {
  Home
  Projects
  Blog
}

pub type Profile {
  Profile(
    first_name: String,
    last_name: String,
    about: List(String),
    contact_info: List(ContactInfo),
  )
}

pub type ContactInfo {
  ContactInfo(label: String, display: String, url: String)
}

pub const profile = Profile(
  "Alessandro",
  "Marcantoni",
  about_lines,
  contact_info,
)

pub const about_lines = [
  "Hi, there! I’m a software and cloud engineer who enjoys turning complex ideas into reliable, real-world products. I’ve worked across the stack—backend, frontend, cloud, and data—building scalable SaaS and IoT systems used in production.",
  "I often lead the technical side of projects, shaping architecture, making pragmatic trade-offs, and taking products from early ideas to production. I’ve worked closely with founders and teams to deliver solutions that are scalable, cost-effective, and easy to evolve.",
  "I care about clean architecture, maintainable code, and systems that scale without unnecessary complexity.",
]

pub const contact_info = [
  ContactInfo(
    "Email",
    "alessandro.marcantoni.98",
    "mailto:alessandro.marcantoni.98@gmail.com",
  ),
  ContactInfo(
    "GitHub",
    "github.com/alessandro-marcantoni",
    "https://github.com/alessandro-marcantoni",
  ),
  ContactInfo(
    "LinkedIn",
    "linkedin.com/in/alessandro-marcantoni",
    "https://www.linkedin.com/in/alessandro-marcantoni-6a2386172/",
  ),
]
