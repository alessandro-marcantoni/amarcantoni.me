export function current() {
  return document.documentElement.dataset.theme ?? "default";
}

export function apply(id) {
  // init re-applies the theme the inline script already set; only animate a
  // real change.
  const animate =
    id !== current() &&
    "startViewTransition" in document &&
    !matchMedia("(prefers-reduced-motion: reduce)").matches;

  if (animate) {
    setRevealOrigin();
    document.startViewTransition(() => set(id));
  } else {
    set(id);
  }
}

function set(id) {
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

// Centers the reveal circle on the switcher, with a radius that reaches the
// farthest corner of the viewport.
function setRevealOrigin() {
  const switcher = document.querySelector('select[aria-label="Color theme"]');
  const rect = switcher?.getBoundingClientRect();
  const x = rect ? rect.left + rect.width / 2 : innerWidth;
  const y = rect ? rect.top + rect.height / 2 : 0;
  const r = Math.hypot(Math.max(x, innerWidth - x), Math.max(y, innerHeight - y));

  const style = document.documentElement.style;
  style.setProperty("--reveal-x", `${x}px`);
  style.setProperty("--reveal-y", `${y}px`);
  style.setProperty("--reveal-r", `${r}px`);
}
