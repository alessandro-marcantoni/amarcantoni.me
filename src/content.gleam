//// Everything the site says about me. Edit this file to update the CV
//// content; the pages only decide how it looks.

import gleam/option.{type Option, None, Some}

pub type Profile {
  Profile(
    first_name: String,
    last_name: String,
    role: String,
    location: String,
    stats: List(Stat),
    about: List(String),
    contact_info: List(ContactInfo),
    experience: List(Experience),
    projects: List(Project),
    education: List(Education),
    languages: List(Language),
    certifications: List(Certification),
    volunteering: List(Experience),
  )
}

pub type Stat {
  Stat(value: String, label: String)
}

pub type ContactInfo {
  ContactInfo(label: String, display: String, url: String)
}

pub type Experience {
  Experience(
    role: String,
    company: String,
    location: Option(String),
    period: String,
    highlights: List(String),
    skills: List(String),
  )
}

pub type Project {
  Project(
    name: String,
    tagline: String,
    url: Option(String),
    highlights: List(String),
    skills: List(String),
  )
}

pub type Education {
  Education(school: String, degree: String, period: String, grade: String)
}

pub type Certification {
  Certification(name: String, issuer: String, period: String, url: String)
}

pub type Language {
  Language(name: String, level: String)
}

pub const profile =
  Profile(
    first_name: "Alessandro",
    last_name: "Marcantoni",
    role: "Cloud & Software Engineer",
    location: "Rimini, Italy",
    stats: stats,
    about: about_lines,
    contact_info: contact_info,
    experience: experience,
    projects: projects,
    education: education,
    languages: languages,
    certifications: certifications,
    volunteering: volunteering,
  )

pub const stats = [
  Stat("3 yrs", "building on AWS"),
  Stat("175k", "users on the IoT platform"),
  Stat("200k", "connected devices"),
  Stat("-96%", "monthly cost on one service"),
]

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

pub const experience = [
  Experience(
    role: "Software Engineer",
    company: "TeamSystem",
    location: None,
    period: "June 2026 - Present",
    highlights: [
      "Designing and building event-driven and REST microservices in Java, Quarkus, and PostgreSQL, modeled with Domain-Driven Design.",
      "Integrating services through Kafka, Dapr, and Azure Service Bus, and deploying them on Kubernetes.",
    ],
    skills: [
      "Java", "Quarkus", "PostgreSQL", "DDD", "Kafka", "Dapr",
      "Azure Service Bus", "Kubernetes",
    ],
  ),
  Experience(
    role: "Cloud Engineer & IT Consultant",
    company: "Connect Reply",
    location: Some("Milan, Italy · Hybrid"),
    period: "April 2023 - May 2026",
    highlights: [
      "Took ownership of end-to-end features in a global IoT platform serving 175,000 users and 200,000 devices, leading technical design, implementation, and rollout of cloud-first IoT solutions with cross-functional teams.",
      "Designed and implemented a cloud solution for a marketing campaign service using AWS Lambda, EventBridge, DynamoDB, SQS, and related services, achieving a 96% reduction in monthly costs.",
      "Upgraded and refactored backend platform components and optimized cloud infrastructure, improving performance, security, maintainability, and reducing compute costs by 40%.",
      "Developed backend applications and REST APIs using Java, Kotlin, and Spring Boot.",
      "Designed the architecture for an LLM-driven data navigator that discovers data in a data lake and exposes it via a natural-language chat interface, including data lake layout, ingestion strategy, and query strategy across heterogeneous datasets.",
    ],
    skills: [
      "AWS", "Java", "Kotlin", "Spring Boot", "Maven", "Python", "GoLang",
      "Terraform", "MySQL", "PostgreSQL", "Docker", "Kubernetes", "CI/CD",
      "LLMs",
    ],
  ),
  Experience(
    role: "Full-Stack Software Engineer",
    company: "Sanascreen",
    location: Some("St. Gallen, Switzerland · Freelance"),
    period: "March 2023 - December 2025",
    highlights: [
      "Co-designed a scalable, cost-effective SaaS architecture, replacing the MVP with a robust production platform.",
      "Built and deployed the full-stack solution, streamlining client onboarding and maintenance and enabling 100k+ CHF in revenue.",
    ],
    skills: ["Kotlin", "Ktor", "TypeScript", "React", "MySQL", "Gradle"],
  ),
  Experience(
    role: "Research Intern",
    company: "University of St. Gallen",
    location: Some("St. Gallen, Switzerland"),
    period: "October 2022 - February 2023",
    highlights: [
      "Contributed to the IntellIoT European project with research and prototypes for innovative IoT solutions.",
      "Designed a visual programming paradigm and implemented an IDE for modeling organizations in Multi-Agent Systems, enabling no-code definition and one-click enforcement.",
    ],
    skills: ["TypeScript", "React", "Kotlin", "Vert.x", "MongoDB", "Docker"],
  ),
  Experience(
    role: "Student Intern",
    company: "University of Bologna",
    location: Some("Cesena, Italy · Part-time"),
    period: "April 2020 - September 2020",
    highlights: [
      "Studied deep learning technologies and face mask detection systems to build a face mask detector that runs on embedded systems.",
      "Tested and compared different approaches quantitatively, then picked the best performing and lightest one.",
      "Deployed the chosen solution on Raspberry Pi and Nvidia Jetson Nano.",
    ],
    skills: ["Python", "TensorFlow", "Deep Learning", "Embedded Systems"],
  ),
]

pub const projects = [
  Project(
    name: "Game, Set, Plan",
    tagline: "SaaS for tennis academies",
    url: Some("https://igor20.com"),
    highlights: [
      "Built a full-stack SaaS to automate training schedules for tennis academies, handling multiple coaches, players, and courts.",
      "Implemented a scheduling algorithm that cut schedule creation time by 70% and delivered a UI refined with coaches and staff.",
    ],
    skills: ["AWS", "Scala", "Python", "Svelte", "TypeScript", "PostgreSQL"],
  ),
  Project(
    name: "Juky",
    tagline: "Modern digital jukebox",
    url: None,
    highlights: [
      "Built a mobile/web app where users can either create \"jukes\" or join existing ones to suggest songs played in a vote-based queue.",
      "Integrated Spotify APIs for music search/playback; used WebSockets for real-time collaboration.",
    ],
    skills: ["Flutter", "Python", "AWS", "DynamoDB", "WebSockets"],
  ),
]

pub const education = [
  Education(
    school: "University of Bologna, Italy",
    degree: "MSc in Computer Science and Engineering",
    period: "2020 - 2023",
    grade: "110/110 cum Laude",
  ),
  Education(
    school: "University of Bologna, Italy",
    degree: "BSc in Computer Science and Engineering",
    period: "2017 - 2020",
    grade: "109/110",
  ),
]

pub const languages = [
  Language("Italian", "Native"),
  Language("English", "C1"),
]

pub const certifications = [
  Certification(
    name: "AWS Certified Cloud Practitioner",
    issuer: "Amazon Web Services",
    period: "Issued Jan 2025 · Expires Jan 2028",
    url: "https://www.credly.com/badges/92648093-eb7b-49ec-8638-996f59063b40",
  ),
]

pub const volunteering = [
  Experience(
    role: "Tennis Coach",
    company: "Tennis Club Riccione",
    location: Some("Riccione, Italy"),
    period: "June 2017 - September 2021",
    highlights: [
      "Taught tennis for four consecutive summers to children from my local community, improving my communication and organization skills.",
    ],
    skills: [],
  ),
]
