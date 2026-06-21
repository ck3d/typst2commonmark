// Test: links, images, references
#import "../../lib.typ": to-commonmark

#let check(name, actual, expected) = {
  if actual == expected {
    metadata("pass")
  } else {
    metadata(("fail", name, expected, actual))
  }
}

#check("link-text", to-commonmark(link("https://example.com")[click here]), "[click here](https://example.com)") <test>
#check("link-autolink", to-commonmark(link("https://example.com")), "<https://example.com>") <test>
#check("link-special", to-commonmark(link("https://example.com/my page")[url]), "[url](<https://example.com/my page>)") <test>
#check("ref", to-commonmark(ref(<my-figure>)), "@my-figure") <test>
#check("image-no-alt", to-commonmark(image("photo.png")), "![](photo.png)") <test>
#check("image-alt", to-commonmark(image("photo.png", alt: "A photo")), "![A photo](photo.png)") <test>
