<div align="center">
  <h1>👑 Tiara</h1>
  <p><strong>A Pure Nim UI Component Library for SSR-first applications.</strong></p>
  <p>
    <a href="https://nim-lang.org/"><img src="https://img.shields.io/badge/nim-%3E%3D_2.2.0-blue.svg?style=flat-square" alt="Nim Version"></a>
    <a href="https://github.com/nimmer-jp/tiara/blob/main/LICENSE"><img src="https://img.shields.io/npm/l/tiara?style=flat-square" alt="License"></a>
  </p>
</div>

---

Tiara is a deeply optimized, headless-inspired UI component library built entirely in Nim. It focuses on Server-Side Rendering (SSR) applications and delivers beautiful, accessible, and fast web experiences without shipping overly bloated JavaScript.

## ✨ Features

- **Pure Nim**: Write your backend, frontend structures, and logic entirely in Nim.
- **SSR-First**: Highly optimized for Server-Side Rendering workflows.
- **Modern Aesthetics**: Sleek, headless, and accessible default designs.
- **Zero-Bloat**: Only ships what you need. Clean HTML outputs.
- **Customizable**: Easy to override default styles manually to fit your brand.

## 📦 Installation

Install via Nimble:

```sh
nimble install tiara
```

_Note: The `website`, `tests`, `docs`, and `examples` directories are excluded from the library payload to keep your installation incredibly fast and lightweight._

## 🚀 Quick Start

Here is a simple example showing how to render a Toast component using Tiara:

```nim
import tiara/components/toast

let myToast = renderToast(
  message = "Action completely successfully!",
  position = "bottom-right",
  duration = 3000
)

echo myToast
```

## 📚 Documentation

For complete documentation, guides, and interactive examples, please visit the [Tiara Official Website](./website) (or refer to the `docs/` folder).

## 🤝 Contributing

We welcome contributions from the community! Feel free to open issues, submit pull requests, or share your ideas on how to improve Tiara.

## 📜 License

This project is licensed under the [MIT License](LICENSE).
