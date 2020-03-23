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

## Problems specific to the _La Peste_ text

### Duplicate lines

Lines are sometimes duplicated, corresponding to page breaks in the PDF. This should be easily corrected by program, as it's unlikely there are intentionally repeated lines in the text.

### Missing hyphens

When words are hyphenated for a line break in the PDF, the hyphen disappears in the text, and the two parts are stuck together. Correcting this requires tedious spotting of all occurrences of such line-ending hyphens in the PDF and adding them by hand back in the text.

Actually many such cases may be automatically found, because such lines are longer than normal, but since it's proportional-width characters, there's no such thing as a standard line length.

## Ideas to do

### Reading out loud 

#### By machine

The text should be in a format suitable for reading out loud by a machine.

Could use, for example, this kind of speech synthesis:
https://www.textfromtospeech.com/en/text-to-voice/
https://stackoverflow.com/questions/21947730/chrome-speech-synthesis-with-longer-texts

#### By humans

Could have optional recording of a reading to complement the machine reading by speech synthesis, which would then be more of a fallback if no human reading is available.

### Read and play

And there could even be a kind of read and play mode, a la YH Chang Industries
