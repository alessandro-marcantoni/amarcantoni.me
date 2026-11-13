export function current() {
  return document.documentElement.dataset.theme ?? "default";
}

export function apply(id) {
  const root = document.documentElement;
  if (id === "default") {
    delete root.dataset.theme;
  } else {
    root.dataset.theme = id;
  }

  // localStorage throws in some private modes; the theme still applies for
  // this visit.
  try {
    localStorage.setItem("theme", id);
  } catch {}

  // Mobile browsers tint their toolbar with theme-color.
  const bg = getComputedStyle(root).getPropertyValue("--color-bg").trim();
  document.querySelector('meta[name="theme-color"]')?.setAttribute("content", bg);
}
