# Implementation notes

This is just to document various choices I made along the way of doing this.

## Format

The best thing I found to start making a readable document is to convert to Markdown.
This requires very little change, mostly adding some blank lines, and presto! the justification happens on its own.

## Chapters

This is what I found to do page breaks, such as to start new chapters:

```html
<div style="page-break-after: always;"></div>
```

Trick found here:

https://stackoverflow.com/questions/22601053/pagebreak-in-markdown-while-creating-pdf