# ⚡ Lucee Kanban Engine

A fast, modern, and lightweight Kanban Board system built with an enterprise-grade backend powered by **Lucee (ColdFusion)** and an ultra-sleek frontend using **Tailwind CSS**, **daisyUI v5**, and **SortableJS**.

---

## 🚀 Tech Stack

| Layer | Technology | Description |
| :--- | :--- | :--- |
| **Backend** | [Lucee v5+](https://lucee.org/) | Open-source ColdFusion (CFML) engine acting as a high-performance REST API wrapper. |
| **Database** | [MySQL 8.0](https://www.mysql.com/) | Relational storage utilizing atomic transaction blocks for indexing board entities. |
| **Frontend** | [Tailwind CSS v4](https://tailwindcss.com/) | Utility-first CSS compiling via runtime runtime parsing engine. |
| **UI Kit** | [daisyUI v5](https://daisyui.com/) | Semantic component framework offering native dark/light theme switching parameters. |
| **UX Engine** | [SortableJS](https://sortablejs.github.io/Sortable/) | No-dependency, fluid drag-and-drop mechanics handling drop behaviors. |

---

## 🎨 UI & Features

*   **Fluid Drag-and-Drop:** Items snap dynamically across columns with responsive velocity metrics using SortableJS.
*   **Modern Typography:** Global structural styles utilize the **Plus Jakarta Sans** geometric display font for maximum crispness.
*   **Contextual Avatars:** Automatic fallback placeholders featuring contrasting foreground initials computed securely by Lucee parsing scripts.
*   **Responsive Flow Layouts:** Dynamic viewport column grids that support seamless horizontal scrolling if your pipeline tracks multiple statuses.

---

## 📁 Project Architecture

```text
your-project/
│
├── db/
│   └── init-db.sql       # Database schemas & sequence initializations
│
├── src/                  # Lucee Context Root (.cfm / .cfc)
│   ├── api/              # Pure backend endpoints (JSON payloads only)
│   │   ├── Application.cfc
│   │   └── update_order.cfm
│   └── index.cfm         # Main visual pipeline viewport template
│
├── docker-compose.yml    # Main stack orchestration layer
└── README.md