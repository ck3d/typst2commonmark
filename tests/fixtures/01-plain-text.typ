// Test: plain text, spaces, edge cases
#import "../../lib.typ": to-commonmark

#let check(name, actual, expected) = {
  if actual == expected {
    metadata("pass")
  } else {
    metadata(("fail", name, expected, actual))
  }
}

#check("plain text", to-commonmark([Hello world]), "Hello world") <test>
#check("spaces", to-commonmark([a b c]), "a b c") <test>
#check("none", to-commonmark(none), "") <test>
#check("empty array", to-commonmark(()), "") <test>
