# HTMS - Hypertext Markup Stylesheets

A small compiler that turns SCSS-like markup into HTML. Selectors become tags, properties become inline styles, and nested rules become nested elements.

## Build

Only a C++20 compiler (`g++`) is required. The lexer and parser are pre-generated and committed to the repo.

```sh
make
```

This produces an `htms` binary in the project root.

To regenerate the lexer/parser from [lexer.l](lexer.l) and [parser.y](parser.y) install [`flex`](https://github.com/westes/flex) and [`bison`](https://www.gnu.org/software/bison/) (≥ 3.8), then:

```sh
make regen-clean && make
```

> macOS note: the bundled bison is too old. Install with `brew install bison` and put it ahead of `/usr/bin` on `PATH`.

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

- **Selectors** — plain identifiers become HTML tag names. `.foo` becomes `<div class="foo">`; `#foo` becomes `<div id="foo">`.
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
