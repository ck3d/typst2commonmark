// Test: lists
#import "../../lib.typ": to-commonmark

#let check(name, actual, expected) = {
  if actual == expected {
    metadata("pass")
  } else {
    metadata(("fail", name, expected, actual))
  }
}

#check("unordered", to-commonmark(list([a], [b], [c])), "- a\n- b\n- c") <test>
#check("ordered", to-commonmark(enum([one], [two], [three])), "1. one\n2. two\n3. three") <test>
#check("list-bold", to-commonmark(list([item with #strong[bold]])), "- item with **bold**") <test>
