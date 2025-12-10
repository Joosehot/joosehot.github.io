# Copilot Instructions for joosehot.github.io

## Project Overview

This is a personal portfolio/blog website built on the **Massively** HTML5 template from HTML5 UP. It's a static HTML5 site with SCSS preprocessing and jQuery-based interactivity. No build system, database, or server-side code—everything is client-side rendered.

**Key constraint**: This is a template-based site. All HTML follows the Massively template structure (header, nav, main, footer pattern). Changes should maintain this consistency.

## Architecture & Structure

### Page Types
- **index.html**: Homepage featuring a hero intro section and post listing
- **generic.html**: Template for individual articles/pages
- **elements.html**: Style guide/reference page showcasing all UI components

All pages share the same layout structure:
```html
<div id="wrapper">
  <div id="intro"> (index.html only)
  <header id="header">
  <nav id="nav">
  <div id="main">
  <footer id="footer">
  <div id="copyright">
```

### Asset Organization
- **assets/css/**: Compiled CSS from SCSS
- **assets/sass/**: SCSS source files (the single source of truth)
  - `libs/`: Shared variables, mixins, functions (`_vars.scss`, `_mixins.scss`, `_breakpoints.scss`)
  - `base/`: Core resets and typography
  - `components/`: Individual UI components (buttons, forms, tables, lists, icons)
  - `layout/`: Page structure (header, nav, footer, wrapper)
- **assets/js/**: jQuery-based interaction (parallax, nav toggle, scroll effects)
- **images/**: Demo/content images

## Development Patterns

### 1. Responsive Design with Breakpoints
The site uses a 7-point breakpoint system defined in `_vars.scss` and implemented via SCSS mixins:
```scss
default (1681px+), xlarge (1281-1680px), large (981-1280px), 
medium (737-980px), small (481-736px), xsmall (361-480px), xxsmall (<360px)
```
Use the `@include breakpoint()` mixin to apply media queries:
```scss
@include breakpoint('<=small') {
  // Mobile-specific styles
}
@include breakpoint('large') {
  // Large desktop styles
}
```

### 2. SCSS Variable & Mixin Usage
**Color Palette** (from `_vars.scss`):
- Defined as `$palette` map with main and `alt` sub-palette
- Access via `_palette(invert, bg)` function for consistent theming
- Common colors: `accent: #18bfef` (cyan), `wrapper-bg: #212931` (dark)

**Key Mixins**:
- `icon()`: Applies FontAwesome styling to pseudo-elements (see `_button.scss` for usage)
- `padding()`: Smart padding that respects element margins
- `color()`: Master mixin applying color scheme to all components

**Variable Access**:
All SCSS values are wrapped in setter functions like `_palette()`, `_size()`, `_font()`.

### 3. CSS Class Naming Conventions
Follow BEM-light patterns used throughout Massively:
- Semantic component classes: `.button`, `.form`, `.post`, `.image`, `.box`
- Modifiers: `.primary`, `.small`, `.fit`, `.alt`, `.disabled`
- Layout utilities: `.row`, `.col-*`, `.section`, `.wrapper`
- State classes: `.active`, `.is-preload`, `.fade-in`

Example from HTML:
```html
<ul class="actions">
  <li><a href="#" class="button primary">Primary</a></li>
  <li><a href="#" class="button">Default</a></li>
</ul>
```

### 4. JavaScript Structure (main.js)
jQuery-driven, self-contained in IIFE pattern:
```javascript
(function($) {
  // Cache DOM elements
  var $window = $(window), $body = $('body'), $header = $('#header');
  
  // Feature: Parallax scrolling via ._parallax() method
  // Feature: Navigation panel toggle for mobile
  // Feature: Scroll-based link highlighting (Scrollex plugin)
  // Feature: Fade-in animations on page load
})($);
```

**Key plugins imported**:
- jQuery Scrollex (scroll event handling)
- jQuery Scrolly (smooth scroll to anchor)
- Responsive Tools (breakpoint detection)

### 5. Color Theming
The entire site uses a palette system. To apply theme colors:
```scss
.my-element {
  background-color: _palette(invert, bg);  // Inverted palette background
  color: _palette(fg);                     // Foreground color
  border-color: _palette(border);
  &.alt {
    background-color: _palette(alt, bg);   // Alt palette
  }
}
```

## Common Tasks

### Adding a New Page
1. Copy `generic.html` as template (maintains header, nav, footer)
2. Update `<title>` and page content in `<section class="post">`
3. Add navigation link in all pages' `<nav id="nav">` `<ul class="links">`
4. Add appropriate `class="active"` to the current page nav item

### Styling New Components
1. Create new `.scss` file in `assets/sass/components/`
2. Import it in `main.scss` with `@import 'components/mycomponent';`
3. Use `@include breakpoint()` for responsive rules
4. Reference colors via `_palette()` function, not hardcoded values
5. Use existing variables: `$size` for spacing, `$font` for typography

### Modifying Breakpoints
Edit `assets/sass/libs/_vars.scss` `$breakpoints` map. Changes sync to both SCSS (`@include breakpoint()`) and JavaScript (`breakpoints()` function).

## No Build System
There is **no package.json, no npm, no webpack**. CSS is pre-compiled (probably by an external tool, possibly VS Code SCSS compiler extension). When editing SCSS:
- Compile to CSS manually (e.g., VS Code SCSS extension or command-line `sass`)
- Output goes to `assets/css/main.css`
- Verify compiled CSS exists before assuming changes are live

## Key Files Reference
- **Template structure**: `index.html`, `generic.html`, `elements.html`
- **Style variables**: `assets/sass/libs/_vars.scss`
- **Reusable mixins**: `assets/sass/libs/_mixins.scss`
- **Component styles**: `assets/sass/components/` (buttons, forms, lists, etc.)
- **Layout**: `assets/sass/layout/` (header, nav, footer structure)
- **Interactivity**: `assets/js/main.js` (parallax, nav toggle, scroll effects)

## Design Philosophy
- **Static site**: No database, all content in HTML
- **Template consistency**: All pages share Massively's semantic structure
- **Responsive-first**: Mobile breakpoints built into SCSS
- **Accessibility**: Uses semantic HTML5 (`<header>`, `<nav>`, `<section>`, `<article>`)
- **FontAwesome icons**: All icons use FontAwesome 5 (`fa-*` classes)

## Notes for AI Agents
- When editing HTML, preserve the wrapper/header/nav/main/footer structure
- When adding CSS, always use SCSS mixins and palette functions (never hardcode colors)
- Update ALL three pages when changing navigation or shared components
- The site uses relative asset paths (`assets/css/main.css`), so it's GitHub Pages ready
- Test at multiple breakpoints: the design is heavily responsive
