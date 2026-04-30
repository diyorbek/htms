# HTMS - Hypertext Markup Stylesheets

A small compiler that turns SCSS-like markup into HTML. Selectors become tags, properties become inline styles, and nested rules become nested elements.

## Build

Requires `flex`, `bison`, and a C++20 compiler (`g++`).

```sh
make
```

This produces an `htms` binary in the project root.

## Usage

`htms` reads source from stdin and writes HTML to stdout.

```sh
echo "div { color: red; span { property: 'hi'; } }" | ./htms
```

Output:

```html
<div style="color:red;">
  <span style="property:'hi';"> </span>
</div>
```

## Syntax

```scss
selector {
  property: value;

  nested-selector {
    property: 23px;
  }
}
```

- **Selectors** — identifiers, optionally prefixed with `.` or `#`. They become HTML tag names.
- **Properties** — `name: value;`. They become entries in the element's `style` attribute.
- **Values** — strings (`'…'` / `"…"`), numbers with optional unit suffix (`23px`, `-1`), identifiers, or space-separated combinations.
- **Nested rules** — emit child elements inside the parent.

## Tests

```sh
make && ./test.sh
```

Green lines pass, red lines fail.

## License

[MIT](LICENSE)
