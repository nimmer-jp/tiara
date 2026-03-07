import ../builder
import ./utils
export utils

proc defaultStyles*(T: typedesc[Tiara]): Html =
  rawHtml("""
<style>
.btn { border: 1px solid transparent; border-radius: 0.5rem; cursor: pointer; font-weight: 600; padding: 0.5rem 0.875rem; }
.btn-primary { background: #0f62fe; border-color: #0f62fe; color: #fff; }
.btn-secondary { background: #f2f4f8; border-color: #d0d7e2; color: #1f2937; }
.btn-small { font-size: 0.875rem; padding: 0.375rem 0.75rem; }
.btn-medium { font-size: 1rem; }
.btn-large { font-size: 1.125rem; padding: 0.625rem 1rem; }
.btn-outline { background: transparent; color: inherit; }

.badge { align-items: center; border: 1px solid transparent; border-radius: 9999px; display: inline-flex; font-weight: 600; gap: 0.35rem; white-space: nowrap; }
.badge-small { font-size: 0.72rem; padding: 0.18rem 0.52rem; }
.badge-medium { font-size: 0.82rem; padding: 0.28rem 0.68rem; }
.badge-large { font-size: 0.92rem; padding: 0.38rem 0.82rem; }
.badge-soft.badge-neutral { background: #eef2ff; color: #334155; }
.badge-soft.badge-accent { background: #f5d0fe; color: #7c3aed; }
.badge-soft.badge-success { background: #dcfce7; color: #166534; }
.badge-soft.badge-warning { background: #fef3c7; color: #92400e; }
.badge-solid.badge-neutral { background: #334155; color: #fff; }
.badge-solid.badge-accent { background: #7c3aed; color: #fff; }
.badge-solid.badge-success { background: #16a34a; color: #fff; }
.badge-solid.badge-warning { background: #d97706; color: #fff; }
.badge-outline.badge-neutral { background: transparent; border-color: #cbd5e1; color: #334155; }
.badge-outline.badge-accent { background: transparent; border-color: #c084fc; color: #7c3aed; }
.badge-outline.badge-success { background: transparent; border-color: #86efac; color: #166534; }
.badge-outline.badge-warning { background: transparent; border-color: #fcd34d; color: #92400e; }

.container { margin: 0 auto; padding-inline: 1rem; width: min(100%, 1200px); }
.container-xl { width: min(100%, 1280px); }

.navbar { align-items: center; display: flex; gap: 1rem; justify-content: space-between; }
.navbar-small { padding: 0.65rem 0.9rem; }
.navbar-medium { padding: 0.95rem 1.15rem; }
.navbar-large { padding: 1.15rem 1.35rem; }
.navbar-glass { backdrop-filter: blur(16px); background: rgba(255, 255, 255, 0.68); border: 1px solid rgba(148, 163, 184, 0.24); border-radius: 1rem; box-shadow: 0 16px 42px rgba(15, 23, 42, 0.12); }
.navbar-solid { background: #fff; border: 1px solid #e2e8f0; border-radius: 1rem; box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08); }
.navbar-minimal { background: transparent; }
.nav-brand { color: #0f172a; font-size: 1.05rem; font-weight: 700; letter-spacing: -0.03em; text-decoration: none; }
.nav-links { align-items: center; display: flex; flex-wrap: wrap; gap: 1rem; }
.nav-link { color: #475569; font-weight: 500; text-decoration: none; }

.hero { align-items: center; display: grid; gap: 2rem; }
.hero-split { grid-template-columns: minmax(0, 1fr) minmax(280px, 0.95fr); }
.hero-stacked { justify-items: center; text-align: center; }
.hero-align-center .hero-content { margin-inline: auto; text-align: center; }
.hero-content { display: grid; gap: 1rem; max-width: 40rem; }
.hero-title { color: #0f172a; font-size: clamp(2.25rem, 5vw, 4.25rem); letter-spacing: -0.04em; line-height: 1.02; margin: 0; }
.hero-description { color: #475569; font-size: 1.05rem; margin: 0; }
.hero-badges { display: flex; flex-wrap: wrap; gap: 0.65rem; }
.hero-actions { display: flex; flex-wrap: wrap; gap: 0.75rem; }
.hero-visual { width: 100%; }

.section-header { align-items: end; display: flex; gap: 1rem; justify-content: space-between; }
.section-header-center { align-items: center; flex-direction: column; text-align: center; }
.section-header-small .section-title { font-size: 1.55rem; }
.section-header-medium .section-title { font-size: 2rem; }
.section-header-large .section-title { font-size: clamp(2.1rem, 4vw, 3rem); }
.section-kicker { color: #7c3aed; font-size: 0.78rem; font-weight: 700; letter-spacing: 0.18em; margin: 0 0 0.7rem; text-transform: uppercase; }
.section-title { color: #0f172a; letter-spacing: -0.04em; line-height: 1.08; margin: 0; }
.section-title-left { text-align: left; }
.section-description { color: #475569; margin: 0.8rem 0 0; max-width: 38rem; }
.section-header-actions { display: flex; flex-wrap: wrap; gap: 0.75rem; }

.card { background: #fff; border: 1px solid #e5e7eb; border-radius: 0.75rem; box-shadow: 0 8px 24px rgba(0,0,0,.06); padding: 1rem; }
.card-title { font-size: 1.125rem; margin: 0 0 0.75rem; }
.card-content { color: #374151; }
.card-elevated { box-shadow: 0 20px 48px rgba(15, 23, 42, 0.14); }
.card-outline { border-color: #cbd5e1; box-shadow: none; }
.card-glass { backdrop-filter: blur(16px); background: rgba(15, 23, 42, 0.72); border-color: rgba(148, 163, 184, 0.22); box-shadow: 0 22px 50px rgba(2, 6, 23, 0.28); }
.card-glass .card-title { color: #f8fafc; }
.card-glass .card-content { color: #cbd5e1; }

.field { display: grid; gap: 0.5rem; }
.field-label { color: #374151; font-size: 0.875rem; font-weight: 500; }
.input { border: 1px solid #d1d5db; border-radius: 0.5rem; padding: 0.5rem 0.75rem; }
.field-color { align-items: center; grid-template-columns: 1fr auto; }
.color-preview { border: 1px solid #d1d5db; border-radius: 9999px; display: inline-block; height: 1.5rem; width: 1.5rem; }

.search-box { display: grid; gap: 0.5rem; }
.search-box-control { align-items: center; display: flex; gap: 0.75rem; transition: border-color 160ms ease, box-shadow 160ms ease, background 160ms ease; }
.search-box-icon { color: #64748b; font-size: 0.95rem; }
.search-box-input { background: transparent; border: none; color: #0f172a; flex: 1; font: inherit; outline: none; }
.search-box-input::placeholder { color: #94a3b8; }
.search-box-subtle .search-box-control { background: #f8fafc; border: 1px solid #e2e8f0; }
.search-box-outline .search-box-control { background: #fff; border: 1px solid #cbd5e1; }
.search-box-ghost .search-box-control { background: transparent; border: 1px dashed #cbd5e1; }
.search-box-small .search-box-control { border-radius: 0.75rem; padding: 0.55rem 0.75rem; }
.search-box-medium .search-box-control { border-radius: 0.9rem; padding: 0.75rem 0.9rem; }
.search-box-large .search-box-control { border-radius: 1rem; padding: 0.95rem 1.1rem; }
.search-box .search-box-control:focus-within { border-color: #a855f7; box-shadow: 0 0 0 4px rgba(168, 85, 247, 0.12); }

.modal { --tiara-motion-ms: 220ms; border: none; border-radius: 0.75rem; max-width: 36rem; opacity: 0; padding: 1rem; transform: translateY(10px) scale(0.985); transition: opacity var(--tiara-motion-ms) cubic-bezier(0.2, 0.7, 0.2, 1), transform var(--tiara-motion-ms) cubic-bezier(0.2, 0.7, 0.2, 1); width: calc(100% - 2rem); }
.modal-medium { max-width: 36rem; }
.modal-small { max-width: 26rem; }
.modal-large { max-width: 48rem; }
.modal::backdrop { background: rgba(15, 23, 42, 0); transition: background var(--tiara-motion-ms) ease; }
.modal.is-open { opacity: 1; transform: translateY(0) scale(1); }
.modal.is-open::backdrop { background: rgba(15, 23, 42, 0.55); }
.modal-actions { display: flex; justify-content: flex-end; margin-top: 1rem; }

.code-block { background: #0b1120; border-radius: 0.75rem; color: #dbeafe; margin: 0; overflow: hidden; }
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

.icon-badge { align-items: center; border: none; display: inline-flex; justify-content: center; position: relative; }
.icon-badge-icon { font-size: 1.25rem; line-height: 1; color: #475569; }
.icon-badge-count { background: #ef4444; border-radius: 9999px; color: #fff; font-size: 0.65rem; font-weight: 600; min-width: 1rem; padding: 0.1rem 0.3rem; position: absolute; right: -0.25rem; text-align: center; top: -0.25rem; }
.notification-icon { background: #f1f5f9; border: none; border-radius: 0.5rem; cursor: pointer; padding: 0.5rem; color: #475569; transition: background 150ms ease; }
.notification-icon:hover { background: #e2e8f0; }

.carousel { border-radius: 0.75rem; overflow: hidden; position: relative; }
.carousel-track { display: flex; transition: transform 220ms ease-out; }
.carousel-slide { flex: 0 0 100%; min-width: 100%; }
.carousel-nav { align-items: center; background: rgba(15, 23, 42, 0.6); border: none; border-radius: 9999px; color: #fff; cursor: pointer; display: inline-flex; font-size: 1rem; height: 2rem; justify-content: center; position: absolute; top: calc(50% - 1rem); width: 2rem; }
.carousel-nav-prev { left: 0.5rem; }
.carousel-nav-next { right: 0.5rem; }
.carousel-indicators { bottom: 0.5rem; display: flex; gap: 0.35rem; left: 50%; position: absolute; transform: translateX(-50%); }
.carousel-indicator { background: rgba(255, 255, 255, 0.55); border: none; border-radius: 9999px; cursor: pointer; height: 0.45rem; width: 0.45rem; }
.carousel-indicator.is-active { background: #fff; width: 1rem; }

.profile-icon { align-items: center; background: #e2e8f0; border-radius: 9999px; color: #475569; display: inline-flex; font-weight: 600; justify-content: center; overflow: hidden; position: relative; text-transform: uppercase; }
.profile-icon-small { font-size: 0.75rem; height: 1.75rem; width: 1.75rem; }
.profile-icon-medium { font-size: 1rem; height: 2.5rem; width: 2.5rem; }
.profile-icon-large { font-size: 1.25rem; height: 3.25rem; width: 3.25rem; }
.profile-icon-image { display: block; height: 100%; object-fit: cover; width: 100%; }
.profile-icon-status { border: 2px solid #fff; border-radius: 9999px; bottom: 0; height: 0.65rem; position: absolute; right: 0; width: 0.65rem; }
.profile-icon-status-online { background: #10b981; }
.profile-icon-status-busy { background: #ef4444; }
.profile-icon-status-away { background: #f59e0b; }

.tabs { border: 1px solid #e5e7eb; border-radius: 0.75rem; overflow: hidden; }
.tabs-list { background: #f8fafc; border-bottom: 1px solid #e5e7eb; display: flex; gap: 0.25rem; padding: 0.35rem; }
.tabs-trigger { background: transparent; border: none; border-radius: 0.5rem; color: #64748b; cursor: pointer; font-weight: 600; padding: 0.5rem 0.75rem; }
.tabs-trigger.is-active { background: #fff; color: #0f172a; box-shadow: 0 1px 2px rgba(15, 23, 42, 0.1); }
.tabs-panels { padding: 0.875rem; }
.tabs-panel { color: #334155; }

.dropdown { --tiara-motion-ms: 180ms; display: inline-block; position: relative; }
.dropdown-toggle { align-items: center; background: #fff; border: 1px solid #d1d5db; border-radius: 0.625rem; cursor: pointer; display: inline-flex; gap: 0.5rem; padding: 0.45rem 0.75rem; }
.dropdown-small .dropdown-toggle { font-size: 0.82rem; padding: 0.35rem 0.65rem; }
.dropdown-large .dropdown-toggle { font-size: 1rem; padding: 0.6rem 0.9rem; }
.dropdown-menu { --tiara-dropdown-x: 0; background: #fff; border: 1px solid #e5e7eb; border-radius: 0.625rem; box-shadow: 0 12px 28px rgba(15, 23, 42, 0.14); list-style: none; margin: 0.45rem 0 0; min-width: 12rem; opacity: 0; padding: 0.35rem; pointer-events: none; position: absolute; transform: translate(var(--tiara-dropdown-x), -6px) scale(0.985); transform-origin: top; transition: opacity var(--tiara-motion-ms) ease, transform var(--tiara-motion-ms) ease; z-index: 20; }
.dropdown-menu.is-open { opacity: 1; pointer-events: auto; transform: translate(var(--tiara-dropdown-x), 0) scale(1); }
.dropdown-menu.is-closing { opacity: 0; pointer-events: none; transform: translate(var(--tiara-dropdown-x), -4px) scale(0.985); }
.dropdown-menu-left { left: 0; --tiara-dropdown-x: 0; }
.dropdown-menu-right { right: 0; --tiara-dropdown-x: 0; }
.dropdown-menu-center { left: 50%; --tiara-dropdown-x: -50%; }
.dropdown-item { border-radius: 0.5rem; margin: 0; padding: 0.4rem 0.55rem; }
.dropdown-item:hover { background: #f1f5f9; }
.dropdown-item.is-disabled { color: #9ca3af; }

.toast { align-items: flex-start; border: 1px solid transparent; border-radius: 0.75rem; display: flex; gap: 0.625rem; max-width: 26rem; padding: 0.75rem 0.875rem; opacity: 0; transform: translateY(10px); transition: opacity 0.3s ease, transform 0.3s ease; }
.toast.is-open { opacity: 1; transform: translateY(0); }
.toast.is-closing { opacity: 0; transform: translateY(-10px); }
.toast-wrapper { position: fixed; z-index: 50; display: flex; flex-direction: column; gap: 0.5rem; pointer-events: none; }
.toast-wrapper > * { pointer-events: auto; }
.toast-top-right { top: 1rem; right: 1rem; }
.toast-top-left { top: 1rem; left: 1rem; }
.toast-bottom-right { bottom: 1rem; right: 1rem; }
.toast-bottom-left { bottom: 1rem; left: 1rem; }
.toast-top-center { top: 1rem; left: 50%; transform: translateX(-50%); }
.toast-bottom-center { bottom: 1rem; left: 50%; transform: translateX(-50%); }
.toast-content { display: grid; gap: 0.15rem; }
.toast-title { color: #0f172a; font-size: 0.9rem; font-weight: 600; }
.toast-message { color: #334155; font-size: 0.875rem; }
.toast-close { background: transparent; border: none; color: #64748b; cursor: pointer; font-size: 0.875rem; line-height: 1; padding: 0.125rem; }
.toast-info { background: #eff6ff; border-color: #bfdbfe; }
.toast-success { background: #ecfdf5; border-color: #86efac; }
.toast-warning { background: #fffbeb; border-color: #fcd34d; }
.toast-error { background: #fef2f2; border-color: #fca5a5; }

@media (max-width: 720px) {
  .navbar { align-items: flex-start; flex-direction: column; }
  .hero-split { grid-template-columns: 1fr; }
  .section-header { align-items: flex-start; flex-direction: column; }
  .section-header-center { align-items: center; }
}
</style>
""")
