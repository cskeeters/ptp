`ptp` is a bash script that uses [shyaml] to parse the [frontmatter] to allow the document to specify which template and filters to apply in order to generate a PDF file via [Typst].

[shyaml]: https://github.com/0k/shyaml
[frontmatter]: https://docs.github.com/en/contributing/writing-for-github-docs/using-yaml-frontmatter
[Typst]: https://github.com/typst/typst

# Example

doc.md:

```markdown
---
title: Typst Article Test
author: Chad Skeeters
# Optional
template: school-paper-local.typ
acronyms:
  LAN: Local Area Network
  WAN: Wide Area Network
filters:
  - acronyms.lua
---

Devices on a +LAN access the +WAN via a gateway, not a router, on most home networks.
```

# Usage

```sh
ptp doc.md
```

## Neovim

To configure neovim, place this in `~/.config/nvim/ftplugin/markdown.lua`.

```lua
-- Pandoc-Typst-PDF (ptp)
vim.keymap.set('n', '<C-k>h', [[<Cmd>!ptp -hv '%'<Cr>]], { buffer=true, desc='Render to Hardcopy PDF via Typst (ptp)' })
vim.keymap.set('n', '<C-k>p', [[<Cmd>!ptp -v '%'<Cr>]], { buffer=true, desc='Render to PDF via Typst (ptp)' })
```

# Installation

First [install shyaml](https://github.com/0k/shyaml?tab=readme-ov-file#installation).

The copy `ptp` to */usr/local/bin/* and ensure execution bits are set.

```sh
curl -LJO https://raw.githubusercontent.com/cskeeters/ptp/refs/heads/master/ptp
sudo mv ptp /usr/local/bin
sudo chmod 755 /usr/local/bin
```
