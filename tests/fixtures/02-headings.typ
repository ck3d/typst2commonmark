// Test: headings
#import "../../lib.typ": to-commonmark

#let check(name, actual, expected) = {
  if actual == expected {
    metadata("pass")
  } else {
    metadata(("fail", name, expected, actual))
  }
}

#let doc = [
= Markup One

== Markup Two
]

#check("h1", to-commonmark(heading(level: 1)[One]), "# One") <test>
#check("h2", to-commonmark(heading(level: 2)[Two]), "## Two") <test>
#check("h6", to-commonmark(heading(level: 6)[Six]), "###### Six") <test>
#check("h7-clamped", to-commonmark(heading(level: 7)[Deep]), "###### Deep") <test>
#check("h2-bold", to-commonmark(heading(level: 2)[Some #strong[bold]]), "## Some **bold**") <test>
#check("markup-h", to-commonmark(doc), "# Markup One\n\n## Markup Two") <test>
