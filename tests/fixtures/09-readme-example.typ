// Test: README example — heading, strong, emph, inline code, list, blockquote
#import "../../lib.typ": to-commonmark

#let check(name, actual, expected) = {
  if actual == expected {
    metadata("pass")
  } else {
    metadata(("fail", name, expected, actual))
  }
}

#let doc = [
  = Introduction

  This is a _Typst_ document with *bold*, `code`, and lists:

  - First
  - Second
  - Third

  #quote(block: true)[A block quote with multiple paragraphs is easy.]
]

#check("readme-example", to-commonmark(doc), "# Introduction\n\nThis is a *Typst* document with **bold**, `code`, and lists:\n\n- First\n- Second\n- Third\n\n> A block quote with multiple paragraphs is easy.") <test>
