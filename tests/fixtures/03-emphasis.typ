// Test: emphasis and strong
#import "../../lib.typ": to-commonmark

#let check(name, actual, expected) = {
  if actual == expected {
    metadata("pass")
  } else {
    metadata(("fail", name, expected, actual))
  }
}

#check("strong", to-commonmark(strong[bold]), "**bold**") <test>
#check("emph", to-commonmark(emph[italic]), "*italic*") <test>
#check("strong>emph", to-commonmark(strong(emph[both])), "**_both_**") <test>
#check("emph>strong", to-commonmark(emph(strong[both])), "*__both__*") <test>
#check("triple", to-commonmark(strong(emph(strong[t]))), "**___t___**") <test>
#check("empty-emph", to-commonmark(emph([])), "") <test>
#check("empty-strong", to-commonmark(strong([])), "") <test>
