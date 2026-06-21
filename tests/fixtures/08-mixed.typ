// Test: comprehensive mixed document
#import "../../lib.typ": to-commonmark

#let check(name, actual, expected) = {
  if actual == expected {
    metadata("pass")
  } else {
    metadata(("fail", name, expected, actual))
  }
}

#let input = [
  = Title

  A paragraph with #emph[emphasis] and #strong[strong].

  - Item A
  - Item B

  > A quote

  #image("pic.png", alt: "pic")
]

#let expected = "# Title\n\nA paragraph with *emphasis* and **strong**.\n\n- Item A\n- Item B\n\n> A quote\n\n![pic](pic.png)"

#check("mixed-doc", to-commonmark(input), expected) <test>
