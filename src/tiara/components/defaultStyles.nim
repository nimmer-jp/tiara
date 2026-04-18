import ../builder
import ./utils
export utils

proc defaultStyles*(T: typedesc[Tiara]): Html =
  rawHtml("""
<style>
:root {
  --tiara-font: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Noto Sans JP", sans-serif;
  --tiara-radius-sm: 0.375rem;
  --tiara-radius-md: 0.5rem;
  --tiara-radius-lg: 0.75rem;
  --tiara-fg: #0f172a;
  --tiara-fg-muted: #64748b;
  --tiara-border: #e2e8f0;
  --tiara-border-strong: #cbd5e1;
  --tiara-surface: #ffffff;
  --tiara-surface-muted: #f8fafc;
  --tiara-surface-subtle: #f1f5f9;
  --tiara-primary: #0f62fe;
  --tiara-primary-hover: #0353e9;
  --tiara-danger: #dc2626;
  --tiara-danger-hover: #b91c1c;
  --tiara-accent: #7c3aed;
  --tiara-shadow-sm: 0 1px 2px rgba(15, 23, 42, 0.05);
  --tiara-shadow-md: 0 4px 14px rgba(15, 23, 42, 0.07);
  --tiara-focus: 0 0 0 2px var(--tiara-surface), 0 0 0 4px rgba(15, 98, 254, 0.35);
}

.btn {
  border: 1px solid transparent;
  border-radius: var(--tiara-radius-md);
  cursor: pointer;
  font-family: inherit;
  font-weight: 600;
  line-height: 1.25;
  padding: 0.5rem 0.9rem;
  transition: background 120ms ease, border-color 120ms ease, color 120ms ease, box-shadow 120ms ease;
}
.btn:focus-visible { box-shadow: var(--tiara-focus); outline: none; }
.btn-primary { background: var(--tiara-primary); border-color: var(--tiara-primary); color: #fff; }
.btn-primary:hover { background: var(--tiara-primary-hover); border-color: var(--tiara-primary-hover); }
.btn-secondary { background: var(--tiara-surface-subtle); border-color: var(--tiara-border-strong); color: var(--tiara-fg); }
.btn-secondary:hover { background: #e8ecf3; border-color: #94a3b8; }
.btn-danger { background: var(--tiara-danger); border-color: var(--tiara-danger); color: #fff; }
.btn-danger:hover { background: var(--tiara-danger-hover); border-color: var(--tiara-danger-hover); }
.btn-ghost { background: transparent; border-color: transparent; color: var(--tiara-fg-muted); }
.btn-ghost:hover { background: var(--tiara-surface-subtle); color: var(--tiara-fg); }
.btn-small { font-size: 0.8125rem; padding: 0.35rem 0.65rem; }
.btn-medium { font-size: 0.9375rem; }
.btn-large { font-size: 1rem; padding: 0.6rem 1.05rem; }
.btn-outline { background: transparent; border-color: var(--tiara-primary); color: var(--tiara-primary); }
.btn-outline:hover { background: rgba(15, 98, 254, 0.06); }
.btn-secondary.btn-outline { border-color: var(--tiara-border-strong); color: var(--tiara-fg); }
.btn-secondary.btn-outline:hover { background: var(--tiara-surface-subtle); }

.badge {
  align-items: center;
  border-radius: 9999px;
  display: inline-flex;
  flex-shrink: 0;
  font-weight: 600;
  gap: 0.35rem;
  line-height: 1.3;
  white-space: nowrap;
}
.badge-small { font-size: 0.6875rem; padding: 0.18rem 0.48rem; }
.badge-medium { font-size: 0.8125rem; padding: 0.26rem 0.62rem; }
.badge-large { font-size: 0.875rem; padding: 0.32rem 0.72rem; }
.badge-soft.badge-neutral { background: var(--tiara-surface-subtle); border: 1px solid var(--tiara-border); color: #475569; }
.badge-soft.badge-accent { background: #f5f3ff; border: 1px solid #e9d5ff; color: #6d28d9; }
.badge-soft.badge-success { background: #ecfdf5; border: 1px solid #bbf7d0; color: #15803d; }
.badge-soft.badge-warning { background: #fffbeb; border: 1px solid #fde68a; color: #b45309; }
.badge-soft.badge-error { background: #fef2f2; border: 1px solid #fecaca; color: #b91c1c; }
.badge-soft.badge-info { background: #eff6ff; border: 1px solid #bfdbfe; color: #1d4ed8; }
.badge-solid.badge-neutral { background: #334155; border: 1px solid #334155; color: #fff; }
.badge-solid.badge-accent { background: var(--tiara-accent); border: 1px solid var(--tiara-accent); color: #fff; }
.badge-solid.badge-success { background: #16a34a; border: 1px solid #16a34a; color: #fff; }
.badge-solid.badge-warning { background: #d97706; border: 1px solid #d97706; color: #fff; }
.badge-solid.badge-error { background: var(--tiara-danger); border: 1px solid var(--tiara-danger); color: #fff; }
.badge-solid.badge-info { background: #2563eb; border: 1px solid #2563eb; color: #fff; }
.badge-outline.badge-neutral { background: var(--tiara-surface); border: 1px solid var(--tiara-border-strong); color: #334155; }
.badge-outline.badge-accent { background: var(--tiara-surface); border: 1px solid #c4b5fd; color: #6d28d9; }
.badge-outline.badge-success { background: var(--tiara-surface); border: 1px solid #86efac; color: #15803d; }
.badge-outline.badge-warning { background: var(--tiara-surface); border: 1px solid #fcd34d; color: #b45309; }
.badge-outline.badge-error { background: var(--tiara-surface); border: 1px solid #fca5a5; color: #b91c1c; }
.badge-outline.badge-info { background: var(--tiara-surface); border: 1px solid #93c5fd; color: #1d4ed8; }

.container { margin: 0 auto; padding-inline: 1rem; width: min(100%, 1200px); }
.container-xl { width: min(100%, 1280px); }

.navbar { align-items: center; display: flex; gap: 1rem; justify-content: space-between; }
.navbar-small { padding: 0.65rem 0.9rem; }
.navbar-medium { padding: 0.95rem 1.15rem; }
.navbar-large { padding: 1.15rem 1.35rem; }
.navbar-glass { backdrop-filter: blur(12px); background: rgba(255, 255, 255, 0.72); border: 1px solid var(--tiara-border); border-radius: var(--tiara-radius-lg); box-shadow: var(--tiara-shadow-md); }
.navbar-solid { background: var(--tiara-surface); border: 1px solid var(--tiara-border); border-radius: var(--tiara-radius-lg); box-shadow: var(--tiara-shadow-sm); }
.navbar-minimal { background: transparent; }
.nav-brand { color: var(--tiara-fg); font-size: 1.05rem; font-weight: 700; letter-spacing: -0.03em; text-decoration: none; }
.nav-links { align-items: center; display: flex; flex-wrap: wrap; gap: 1rem; }
.nav-link { color: #475569; font-weight: 500; text-decoration: none; }
.nav-link:hover { color: var(--tiara-fg); }

.hero { align-items: center; display: grid; gap: 2rem; }
.hero-split { grid-template-columns: minmax(0, 1fr) minmax(280px, 0.95fr); }
.hero-stacked { justify-items: center; text-align: center; }
.hero-align-center .hero-content { margin-inline: auto; text-align: center; }
.hero-content { display: grid; gap: 1rem; max-width: 40rem; }
.hero-title { color: var(--tiara-fg); font-size: clamp(2.25rem, 5vw, 4.25rem); letter-spacing: -0.04em; line-height: 1.02; margin: 0; }
.hero-description { color: #475569; font-size: 1.05rem; margin: 0; }
.hero-badges { display: flex; flex-wrap: wrap; gap: 0.65rem; }
.hero-actions { display: flex; flex-wrap: wrap; gap: 0.75rem; }
.hero-visual { width: 100%; }

.section-header { align-items: end; display: flex; gap: 1rem; justify-content: space-between; }
.section-header-center { align-items: center; flex-direction: column; text-align: center; }
.section-header-small .section-title { font-size: 1.55rem; }
.section-header-medium .section-title { font-size: 2rem; }
.section-header-large .section-title { font-size: clamp(2.1rem, 4vw, 3rem); }
.section-kicker { color: var(--tiara-accent); font-size: 0.75rem; font-weight: 700; letter-spacing: 0.14em; margin: 0 0 0.65rem; text-transform: uppercase; }
.section-title { color: var(--tiara-fg); letter-spacing: -0.03em; line-height: 1.1; margin: 0; }
.section-title-left { text-align: left; }
.section-description { color: #475569; margin: 0.75rem 0 0; max-width: 38rem; }
.section-header-actions { display: flex; flex-wrap: wrap; gap: 0.75rem; }

.card {
  background: var(--tiara-surface);
  border: 1px solid var(--tiara-border);
  border-radius: var(--tiara-radius-lg);
  box-shadow: var(--tiara-shadow-sm);
  padding: 1.1rem;
}
.card-title { color: var(--tiara-fg); font-size: 1.0625rem; font-weight: 600; margin: 0 0 0.65rem; }
.card-content { color: #374151; font-size: 0.9375rem; line-height: 1.55; }
.card-elevated { box-shadow: var(--tiara-shadow-md); }
.card-outline { border-color: var(--tiara-border-strong); box-shadow: none; }
.card-subtle { background: var(--tiara-surface-muted); border-color: var(--tiara-border); box-shadow: none; }
.card-flat { background: var(--tiara-surface); border: 1px solid var(--tiara-border); box-shadow: none; }
.card-glass { backdrop-filter: blur(12px); background: rgba(15, 23, 42, 0.78); border-color: rgba(148, 163, 184, 0.2); box-shadow: var(--tiara-shadow-md); }
.card-glass .card-title { color: #f8fafc; }
.card-glass .card-content { color: #cbd5e1; }

.field { display: grid; gap: 0.45rem; }
.field-label { color: #374151; font-size: 0.8125rem; font-weight: 500; }
.input {
  border: 1px solid var(--tiara-border-strong);
  border-radius: var(--tiara-radius-md);
  font-family: inherit;
  font-size: 0.9375rem;
  padding: 0.5rem 0.75rem;
  transition: border-color 120ms ease, box-shadow 120ms ease;
}
.input:focus { border-color: var(--tiara-primary); box-shadow: var(--tiara-focus); outline: none; }
.textarea {
  border: 1px solid var(--tiara-border-strong);
  border-radius: var(--tiara-radius-md);
  box-sizing: border-box;
  font-family: inherit;
  font-size: 0.9375rem;
  line-height: 1.45;
  min-height: 5rem;
  padding: 0.5rem 0.75rem;
  resize: vertical;
  transition: border-color 120ms ease, box-shadow 120ms ease;
  width: 100%;
}
.textarea:focus { border-color: var(--tiara-primary); box-shadow: var(--tiara-focus); outline: none; }

.app-shell { box-sizing: border-box; display: grid; grid-template-columns: minmax(220px, 300px) minmax(0, 1fr); min-height: 100vh; width: 100%; }
.app-shell-sidebar { background: var(--tiara-surface-muted); border-right: 1px solid var(--tiara-border); box-sizing: border-box; display: flex; flex-direction: column; min-height: 0; min-width: 0; }
.app-shell-main { background: var(--tiara-surface); box-sizing: border-box; display: flex; flex-direction: column; min-height: 0; min-width: 0; }

.chat-sidebar { box-sizing: border-box; display: flex; flex-direction: column; gap: 0.65rem; height: 100%; min-height: 0; padding: 0.85rem; }
.chat-sidebar-header { border-bottom: 1px solid var(--tiara-border); margin: -0.85rem -0.85rem 0; padding: 0.65rem 0.85rem; }
.chat-sidebar-body { display: flex; flex: 1; flex-direction: column; gap: 0.35rem; min-height: 0; overflow-y: auto; }
.chat-session-item { border-radius: var(--tiara-radius-md); cursor: pointer; padding: 0.55rem 0.65rem; transition: background 120ms ease; }
.chat-session-item:hover { background: var(--tiara-surface-subtle); }
.chat-session-item.is-active { background: #e8f0ff; border: 1px solid #bfdbfe; }
.chat-session-title { color: var(--tiara-fg); font-size: 0.9rem; font-weight: 600; line-height: 1.25; }
.chat-session-meta { color: var(--tiara-fg-muted); font-size: 0.75rem; margin-top: 0.15rem; }
.chat-bubble { display: flex; margin: 0.35rem 0; }
.chat-bubble-content { border-radius: var(--tiara-radius-lg); font-size: 0.9375rem; line-height: 1.5; max-width: min(100%, 42rem); padding: 0.55rem 0.75rem; white-space: pre-wrap; }
.chat-bubble-assistant { justify-content: flex-start; }
.chat-bubble-assistant .chat-bubble-content { background: var(--tiara-surface-subtle); border: 1px solid var(--tiara-border); color: var(--tiara-fg); }
.chat-bubble-user { justify-content: flex-end; }
.chat-bubble-user .chat-bubble-content { background: rgba(15, 98, 254, 0.12); border: 1px solid rgba(15, 98, 254, 0.25); color: var(--tiara-fg); }
.chat-bubble-system { justify-content: center; }
.chat-bubble-system .chat-bubble-content { background: transparent; border: 1px dashed var(--tiara-border-strong); color: var(--tiara-fg-muted); font-size: 0.8125rem; max-width: 36rem; text-align: center; }

.chat-composer { border-top: 1px solid var(--tiara-border); display: flex; flex-direction: column; gap: 0.55rem; margin-top: auto; padding: 0.75rem 0 0; }
.chat-composer-field { min-width: 0; }
.chat-composer-input { min-height: 3.5rem; }
.chat-composer-actions { align-items: center; display: flex; flex-wrap: wrap; gap: 0.5rem; justify-content: flex-end; }
.chat-composer-trailing { align-items: center; display: flex; flex: 1; flex-wrap: wrap; gap: 0.5rem; min-width: 0; }

.alert-banner { border: 1px solid var(--tiara-border); border-radius: var(--tiara-radius-md); font-size: 0.9rem; line-height: 1.45; padding: 0.75rem 0.85rem; }
.alert-banner-title { font-weight: 700; margin-bottom: 0.25rem; }
.alert-banner-message { margin: 0; }
.alert-banner-info { background: #eff6ff; border-color: #bfdbfe; color: #1e3a8a; }
.alert-banner-warning { background: #fffbeb; border-color: #fde68a; color: #92400e; }
.alert-banner-error { background: #fef2f2; border-color: #fecaca; color: #991b1b; }
.alert-banner-success { background: #ecfdf5; border-color: #bbf7d0; color: #14532d; }

.setup-card { background: var(--tiara-surface); border: 1px solid var(--tiara-border); border-radius: var(--tiara-radius-lg); box-shadow: var(--tiara-shadow-sm); padding: 1rem 1.1rem; }
.setup-card-header { align-items: flex-start; display: flex; flex-wrap: wrap; gap: 0.5rem 0.75rem; justify-content: space-between; margin-bottom: 0.75rem; }
.setup-card-step { background: var(--tiara-surface-subtle); border: 1px solid var(--tiara-border); border-radius: 9999px; color: var(--tiara-fg-muted); display: inline-block; font-size: 0.75rem; font-weight: 600; padding: 0.15rem 0.55rem; }
.setup-card-title { color: var(--tiara-fg); flex: 1; font-size: 1.05rem; font-weight: 600; line-height: 1.25; margin: 0; min-width: 0; }
.setup-card-optional-badge { background: #fffbeb; border: 1px solid #fde68a; border-radius: 9999px; color: #b45309; font-size: 0.75rem; font-weight: 600; padding: 0.15rem 0.55rem; white-space: nowrap; }
.setup-card-body { color: #374151; font-size: 0.9375rem; line-height: 1.55; }

.field-validation { font-size: 0.8125rem; line-height: 1.4; margin: 0.25rem 0 0; }
.field-validation-error { color: var(--tiara-danger); }
.field-validation-warning { color: #b45309; }
.field-validation-success { color: #15803d; }
.field-validation-hint { color: var(--tiara-fg-muted); }

.field-color { align-items: center; grid-template-columns: 1fr auto; }
.color-preview { border: 1px solid var(--tiara-border-strong); border-radius: 9999px; display: inline-block; height: 1.5rem; width: 1.5rem; }

.search-box { display: grid; gap: 0.45rem; }
.search-box-control { align-items: center; border-radius: var(--tiara-radius-md); display: flex; gap: 0.65rem; transition: border-color 120ms ease, box-shadow 120ms ease; }
.search-box-icon { color: var(--tiara-fg-muted); font-size: 0.9rem; }
.search-box-input { background: transparent; border: none; color: var(--tiara-fg); flex: 1; font: inherit; outline: none; }
.search-box-input::placeholder { color: #94a3b8; }
.search-box-subtle .search-box-control { background: var(--tiara-surface-muted); border: 1px solid var(--tiara-border); }
.search-box-outline .search-box-control { background: var(--tiara-surface); border: 1px solid var(--tiara-border-strong); }
.search-box-ghost .search-box-control { background: transparent; border: 1px dashed var(--tiara-border-strong); }
.search-box-small .search-box-control { border-radius: var(--tiara-radius-sm); padding: 0.5rem 0.65rem; }
.search-box-medium .search-box-control { padding: 0.65rem 0.8rem; }
.search-box-large .search-box-control { border-radius: var(--tiara-radius-lg); padding: 0.85rem 1rem; }
.search-box .search-box-control:focus-within { border-color: var(--tiara-primary); box-shadow: var(--tiara-focus); }

.modal { --tiara-motion-ms: 220ms; border: none; border-radius: var(--tiara-radius-lg); max-width: 36rem; opacity: 0; padding: 1.15rem; transform: translateY(10px) scale(0.985); transition: opacity var(--tiara-motion-ms) cubic-bezier(0.2, 0.7, 0.2, 1), transform var(--tiara-motion-ms) cubic-bezier(0.2, 0.7, 0.2, 1); width: calc(100% - 2rem); }
.modal-medium { max-width: 36rem; }
.modal-small { max-width: 26rem; }
.modal-large { max-width: 48rem; }
.modal::backdrop { background: rgba(15, 23, 42, 0); transition: background var(--tiara-motion-ms) ease; }
.modal.is-open { opacity: 1; transform: translateY(0) scale(1); }
.modal.is-open::backdrop { background: rgba(15, 23, 42, 0.5); }
.modal-actions { display: flex; justify-content: flex-end; margin-top: 1rem; }

.code-block { background: #0b1120; border-radius: var(--tiara-radius-lg); color: #dbeafe; margin: 0; overflow: hidden; }
.code-block-terminal { background: #070b16; }
.code-block-header { align-items: center; background: #111827; display: flex; justify-content: space-between; padding: 0.5rem 0.75rem; }
.code-block-header-terminal { background: #0f172a; }
.code-block-header-main { align-items: center; display: flex; gap: 0.65rem; min-width: 0; }
.code-block-traffic { align-items: center; display: inline-flex; gap: 0.35rem; }
.code-block-dot { border-radius: 9999px; display: inline-block; height: 0.65rem; width: 0.65rem; }
.code-block-dot-red { background: #fb7185; }
.code-block-dot-yellow { background: #fbbf24; }
.code-block-dot-green { background: #34d399; }
.code-block-title { color: #e5e7eb; font-size: 0.875rem; font-weight: 600; }
.code-block-language { color: #9ca3af; font-family: ui-monospace, SFMono-Regular, Menlo, monospace; font-size: 0.75rem; letter-spacing: 0.06em; }
.code-block-pre { margin: 0; overflow-x: auto; padding: 0.875rem; }
.code-block-code { display: block; font-family: ui-monospace, SFMono-Regular, Menlo, monospace; font-size: 0.875rem; line-height: 1.5; white-space: pre; }
.code-token.code-keyword { color: #c4b5fd; }
.code-token.code-string { color: #fde68a; }
.code-token.code-number { color: #67e8f9; }
.code-token.code-comment { color: #6b7280; font-style: italic; }

.icon-badge { align-items: center; border: none; box-sizing: border-box; display: inline-flex; flex-shrink: 0; justify-content: center; min-height: 2.5rem; min-width: 2.5rem; padding: 0.35rem; position: relative; vertical-align: middle; }
.icon-badge-icon { align-items: center; color: var(--tiara-fg-muted); display: inline-flex; font-size: 1.2rem; line-height: 1; }
.icon-badge-count { align-items: center; background: var(--tiara-danger); border: 1px solid #fff; border-radius: 9999px; color: #fff; display: inline-flex; font-size: 0.6rem; font-weight: 600; justify-content: center; line-height: 1; min-height: 1.05rem; min-width: 1.05rem; padding: 0 0.22rem; position: absolute; right: 0.2rem; text-align: center; top: 0.2rem; }
.notification-icon-default { background: var(--tiara-surface-subtle); border: 1px solid var(--tiara-border-strong); border-radius: var(--tiara-radius-md); color: #475569; cursor: pointer; min-height: 2.5rem; min-width: 2.5rem; padding: 0.4rem; transition: background 120ms ease, border-color 120ms ease, color 120ms ease; }
.notification-icon-default:hover { background: #e8ecf3; border-color: #94a3b8; color: var(--tiara-fg); }
.notification-icon-subtle { background: var(--tiara-surface); border: 1px solid var(--tiara-border); border-radius: var(--tiara-radius-md); color: var(--tiara-fg-muted); cursor: pointer; min-height: 2.5rem; min-width: 2.5rem; padding: 0.4rem; transition: background 120ms ease, border-color 120ms ease; }
.notification-icon-subtle:hover { background: var(--tiara-surface-muted); border-color: var(--tiara-border-strong); color: var(--tiara-fg); }
.notification-icon-ghost { background: transparent; border: 1px dashed var(--tiara-border-strong); border-radius: var(--tiara-radius-md); color: var(--tiara-fg-muted); cursor: pointer; min-height: 2.5rem; min-width: 2.5rem; padding: 0.4rem; }
.notification-icon-ghost:hover { background: var(--tiara-surface-muted); border-style: solid; color: var(--tiara-fg); }
.notification-icon-solid { background: var(--tiara-fg); border: 1px solid var(--tiara-fg); border-radius: var(--tiara-radius-md); color: #fff; cursor: pointer; min-height: 2.5rem; min-width: 2.5rem; padding: 0.4rem; transition: background 120ms ease, border-color 120ms ease; }
.notification-icon-solid:hover { background: #1e293b; border-color: #1e293b; }
.notification-icon-solid .icon-badge-count { border-color: var(--tiara-fg); }

.profile-icon { align-items: center; border-radius: 9999px; display: inline-flex; flex-shrink: 0; font-weight: 600; justify-content: center; letter-spacing: 0.02em; overflow: visible; position: relative; text-transform: uppercase; }
.profile-icon-neutral { background: #e2e8f0; border: 1px solid var(--tiara-border-strong); color: #475569; }
.profile-icon-brand { background: #ede9fe; border: 1px solid #ddd6fe; color: #5b21b6; }
.profile-icon-dark { background: #1e293b; border: 1px solid #0f172a; color: #f1f5f9; }
.profile-icon-small { font-size: 0.65rem; height: 1.85rem; width: 1.85rem; }
.profile-icon-medium { font-size: 0.88rem; height: 2.5rem; width: 2.5rem; }
.profile-icon-large { font-size: 1.05rem; height: 3.25rem; width: 3.25rem; }
.profile-icon-initials { font-weight: 600; line-height: 1; }
.profile-icon-image { border-radius: 50%; display: block; height: 100%; object-fit: cover; width: 100%; }
.profile-icon-status { border: 2px solid #fff; border-radius: 9999px; bottom: -0.05rem; height: 0.65rem; position: absolute; right: -0.05rem; width: 0.65rem; }
.profile-icon-status-online { background: #10b981; }
.profile-icon-status-busy { background: #ef4444; }
.profile-icon-status-away { background: #f59e0b; }

.carousel { border-radius: var(--tiara-radius-lg); overflow: hidden; position: relative; }
.carousel-track { display: flex; transition: transform 220ms ease-out; }
.carousel-slide { flex: 0 0 100%; min-width: 100%; }
.carousel-nav { align-items: center; background: rgba(15, 23, 42, 0.55); border: none; border-radius: 9999px; color: #fff; cursor: pointer; display: inline-flex; font-size: 1rem; height: 2rem; justify-content: center; position: absolute; top: calc(50% - 1rem); width: 2rem; }
.carousel-nav-prev { left: 0.5rem; }
.carousel-nav-next { right: 0.5rem; }
.carousel-indicators { bottom: 0.5rem; display: flex; gap: 0.35rem; left: 50%; position: absolute; transform: translateX(-50%); }
.carousel-indicator { background: rgba(255, 255, 255, 0.55); border: none; border-radius: 9999px; cursor: pointer; height: 0.45rem; width: 0.45rem; }
.carousel-indicator.is-active { background: #fff; width: 1rem; }

.tabs { border: 1px solid var(--tiara-border); border-radius: var(--tiara-radius-lg); overflow: hidden; }
.tabs-list { background: var(--tiara-surface-muted); border-bottom: 1px solid var(--tiara-border); display: flex; gap: 0.2rem; padding: 0.3rem; }
.tabs-trigger { background: transparent; border: none; border-radius: var(--tiara-radius-sm); color: var(--tiara-fg-muted); cursor: pointer; font-weight: 600; padding: 0.45rem 0.7rem; }
.tabs-trigger.is-active { background: var(--tiara-surface); color: var(--tiara-fg); box-shadow: var(--tiara-shadow-sm); }
.tabs-panels { padding: 0.85rem; }
.tabs-panel { color: #334155; }

.dropdown { --tiara-motion-ms: 180ms; display: inline-block; max-width: 100%; position: relative; width: fit-content; z-index: 1; }
.dropdown[data-tiara-dropdown-open="true"] { z-index: 250; }
.dropdown-toggle {
  align-items: center;
  background: var(--tiara-surface);
  border: 1px solid var(--tiara-border-strong);
  border-radius: var(--tiara-radius-md);
  color: var(--tiara-fg);
  cursor: pointer;
  display: inline-flex;
  font-weight: 600;
  gap: 0.4rem;
  padding: 0.45rem 0.75rem;
  transition: border-color 120ms ease, background 120ms ease;
}
.dropdown-toggle::after { border-bottom: 2px solid currentColor; border-right: 2px solid currentColor; content: ""; display: inline-block; height: 0.35rem; margin-left: 0.1rem; opacity: 0.45; transform: rotate(45deg); width: 0.35rem; }
.dropdown[data-tiara-dropdown-open="true"] .dropdown-toggle::after { margin-top: 0.1rem; transform: rotate(225deg); }
.dropdown-toggle:hover { border-color: #94a3b8; background: var(--tiara-surface-muted); }
.dropdown-small .dropdown-toggle { font-size: 0.8125rem; padding: 0.32rem 0.6rem; }
.dropdown-large .dropdown-toggle { font-size: 1rem; padding: 0.55rem 0.85rem; }
.dropdown-menu { --tiara-dropdown-x: 0; background: var(--tiara-surface); border: 1px solid var(--tiara-border); border-radius: var(--tiara-radius-md); box-shadow: var(--tiara-shadow-md); list-style: none; margin: 0.45rem 0 0; min-width: 12rem; opacity: 0; padding: 0.3rem; pointer-events: none; position: absolute; top: 100%; transform: translate(var(--tiara-dropdown-x), -6px) scale(0.985); transition: opacity var(--tiara-motion-ms) ease, transform var(--tiara-motion-ms) ease; z-index: 300; }
.dropdown-menu.is-open { opacity: 1; pointer-events: auto; transform: translate(var(--tiara-dropdown-x), 0) scale(1); }
.dropdown-menu.is-closing { opacity: 0; pointer-events: none; transform: translate(var(--tiara-dropdown-x), -4px) scale(0.985); }
.dropdown-menu-left { left: 0; right: auto; --tiara-dropdown-x: 0; transform-origin: top left; }
.dropdown-menu-right { left: auto; right: 0; --tiara-dropdown-x: 0; transform-origin: top right; }
.dropdown-menu-center { left: 50%; right: auto; --tiara-dropdown-x: -50%; transform-origin: top center; }
.dropdown-item { border-radius: var(--tiara-radius-sm); margin: 0; padding: 0.4rem 0.55rem; }
.dropdown-item:hover { background: var(--tiara-surface-muted); }
.dropdown-item.is-disabled { color: #9ca3af; }

.toast-wrapper {
  position: fixed !important;
  z-index: 999999 !important;
  display: flex !important;
  flex-direction: column !important;
  gap: 0.75rem !important;
  pointer-events: none !important;
  padding: 1.5rem !important;
  width: auto !important;
  height: auto !important;
  max-width: 100vw !important;
  max-height: 100vh !important;
  overflow: visible !important;
  visibility: visible !important;
}
.toast-top-right { top: 1rem !important; right: 1rem !important; align-items: flex-end !important; }
.toast-top-left { top: 1rem !important; left: 1rem !important; align-items: flex-start !important; }
.toast-bottom-right { bottom: 1rem !important; right: 1rem !important; align-items: flex-end !important; }
.toast-bottom-left { bottom: 1rem !important; left: 1rem !important; align-items: flex-start !important; }
.toast-top-center { top: 1rem !important; left: 50% !important; transform: translateX(-50%) !important; align-items: center !important; }
.toast-bottom-center { bottom: 1rem !important; left: 50% !important; transform: translateX(-50%) !important; align-items: center !important; }

.toast {
  display: flex !important;
  align-items: flex-start !important;
  backdrop-filter: blur(8px);
  background: rgba(255, 255, 255, 0.96) !important;
  border: 1px solid var(--tiara-border) !important;
  border-radius: var(--tiara-radius-lg) !important;
  box-shadow: var(--tiara-shadow-md) !important;
  gap: 0.75rem !important;
  width: 22rem !important;
  max-width: calc(100vw - 3rem) !important;
  padding: 0.95rem 1rem !important;
  pointer-events: auto !important;
  transition: opacity 0.35s ease, transform 0.35s ease !important;
  opacity: 0 !important;
  visibility: hidden;
  color: var(--tiara-fg) !important;
  margin-bottom: 0.5rem !important;
}
.toast.is-open {
  opacity: 1 !important;
  visibility: visible !important;
  transform: translateY(0) scale(1) !important;
}
.toast-wrapper[class*="top-"] .toast { transform: translateY(-0.75rem) scale(0.97); }
.toast-wrapper[class*="bottom-"] .toast { transform: translateY(0.75rem) scale(0.97); }
.toast.is-closing { opacity: 0 !important; transform: scale(0.96) !important; }

.toast-content { display: grid !important; gap: 0.2rem !important; flex: 1 !important; }
.toast-title { color: var(--tiara-fg) !important; font-size: 0.9rem !important; font-weight: 600 !important; margin: 0 !important; }
.toast-message { color: #475569 !important; font-size: 0.875rem !important; line-height: 1.5 !important; margin: 0 !important; }
.toast-close { background: transparent !important; border: none !important; color: #94a3b8 !important; cursor: pointer !important; font-size: 1.15rem !important; padding: 0.2rem !important; display: flex !important; align-items: center !important; justify-content: center !important; border-radius: var(--tiara-radius-sm) !important; transition: background 120ms ease, color 120ms ease !important; }
.toast-close:hover { color: var(--tiara-fg) !important; background: var(--tiara-surface-subtle) !important; }

.toast-info { border-left: 3px solid #2563eb !important; }
.toast-success { border-left: 3px solid #16a34a !important; }
.toast-warning { border-left: 3px solid #d97706 !important; }
.toast-error { border-left: 3px solid var(--tiara-danger) !important; }

@media (prefers-color-scheme: dark) {
  .toast { background: rgba(30, 41, 59, 0.96) !important; border-color: #334155 !important; color: #f1f5f9 !important; }
  .toast-title { color: #f1f5f9 !important; }
  .toast-message { color: #94a3b8 !important; }
  .toast-close:hover { color: #f1f5f9 !important; background: rgba(255,255,255,0.08) !important; }
}

@media (max-width: 960px) {
  .app-shell { grid-template-columns: 1fr; }
  .app-shell-sidebar { border-bottom: 1px solid var(--tiara-border); border-right: none; max-height: 40vh; }
}

@media (max-width: 720px) {
  .navbar { align-items: flex-start; flex-direction: column; }
  .hero-split { grid-template-columns: 1fr; }
  .section-header { align-items: flex-start; flex-direction: column; }
  .section-header-center { align-items: center; }
}
</style>
""")
