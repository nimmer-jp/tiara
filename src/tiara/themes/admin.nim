import ../builder
import ../components/utils
export utils

proc adminTheme*(T: typedesc[Tiara]): Html =
  ## Admin dashboard theme extension. Include after `defaultStyles()`.
  rawHtml("""
<style>
:root {
  --page-bg: var(--tiara-surface-muted);
  --page-fg: var(--tiara-fg);
  --page-border: var(--tiara-border);
  --admin-sidebar-bg: var(--tiara-surface-muted);
  --admin-main-bg: var(--tiara-surface);
}

body {
  background: var(--page-bg);
  color: var(--page-fg);
  font-family: var(--tiara-font);
}

.admin-layout .dashboard-shell-sidebar {
  background: var(--admin-sidebar-bg);
}

.admin-layout .dashboard-shell-main {
  background: var(--admin-main-bg);
}

.admin-layout-brand-block {
  border-bottom: 1px solid var(--page-border);
  margin: -0.15rem 0 0.35rem;
  padding-bottom: 0.85rem;
}

.admin-layout-brand {
  color: var(--tiara-fg);
  font-size: 1.05rem;
  letter-spacing: -0.02em;
  line-height: 1.2;
  margin: 0;
}

.admin-layout-subtitle {
  color: var(--tiara-fg-muted);
  font-size: 0.78rem;
  margin: 0.35rem 0 0;
}

.admin-layout-nav {
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
}

.admin-nav-link {
  border-radius: var(--tiara-radius-md);
  color: #475569;
  display: block;
  font-size: 0.9rem;
  font-weight: 600;
  padding: 0.55rem 0.7rem;
  text-decoration: none;
  transition: background 120ms ease, color 120ms ease;
}

.admin-nav-link:hover {
  background: var(--tiara-surface-subtle);
  color: var(--tiara-fg);
}

.admin-nav-link.is-active {
  background: #e8f0ff;
  border: 1px solid #bfdbfe;
  color: #1e3a8a;
}

.admin-layout-footer {
  border-top: 1px solid var(--page-border);
  margin-top: auto;
  padding-top: 0.85rem;
}

.admin-layout-sidebar-inner {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  min-height: 100%;
}
</style>
""")
