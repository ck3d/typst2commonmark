// Test: blockquotes, linebreaks, parbreaks, dropped elements
#import "../../lib.typ": to-commonmark

#let check(name, actual, expected) = {
  if actual == expected {
    metadata("pass")
  } else {
    metadata(("fail", name, expected, actual))
  }
}

#check("bq-simple", to-commonmark(quote(block: true)[A simple quote]), "> A simple quote") <test>
#check("bq-para", to-commonmark(quote(block: true)[Para one #parbreak() Para two]), "> Para one\n>\n> Para two") <test>
#check("bq-list", to-commonmark(quote(block: true)[Contains #list([a], [b])]), "> Contains\n>\n> - a\n> - b") <test>
#check("linebreak", to-commonmark([Before #linebreak() After]), "Before \\\\\n After") <test>
#check("parbreak", to-commonmark([First] + parbreak() + [Second]), "First\n\nSecond") <test>
#check("drop-eq", to-commonmark($ "x^2" $), "<!-- dropped: equation -->") <test>
#check("drop-table", to-commonmark(table(table.cell([a]), table.cell([b]))), "<!-- dropped: table -->") <test>
#check("drop-label", to-commonmark([Text with #label("x")]), "Text with") <test>
