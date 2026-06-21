// Test: code spans and fenced code blocks
#import "../../lib.typ": to-commonmark

#let check(name, actual, expected) = {
  if actual == expected {
    metadata("pass")
  } else {
    metadata(("fail", name, expected, actual))
  }
}

#check("inline-code", to-commonmark(raw("x + y")), "`x + y`") <test>
#check("inline-backtick", to-commonmark(raw("has `bt`")), "`` has `bt` ``") <test>
#check("fenced", to-commonmark(raw("a = 1\nb = 2", lang: "python", block: true)), "```python\na = 1\nb = 2\n```") <test>
#check("fenced-backticks", to-commonmark(raw("has `` in it", lang: "", block: true)), "```\nhas `` in it\n```") <test>
