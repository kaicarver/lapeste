# Implementation notes

This is just to document various choices I made along the way of doing this.

- [Implementation notes](#implementation-notes)
  - [General](#general)
    - [TOC](#toc)
    - [Format](#format)
    - [Chapters](#chapters)
  - [_La Peste_](#la-peste)
    - [Duplicate lines](#duplicate-lines)
    - [Missing hyphens](#missing-hyphens)
    - [Closing quotes wrong?](#closing-quotes-wrong)
    - [Special paragraph breaks](#special-paragraph-breaks)
    - [Generating HTML etc.](#generating-html-etc)
    - [Mme](#mme)
  - [_Ignition!_](#ignition)
    - [First look](#first-look)
      - [Extra space](#extra-space)
      - [Hyphenated words](#hyphenated-words)
      - [Chapter headers and page numbers separating pages](#chapter-headers-and-page-numbers-separating-pages)
    - [Photos](#photos)
    - [Layout help](#layout-help)
    - [em dash vs en dash?](#em-dash-vs-en-dash)
    - [dash separated by space, and minus sign](#dash-separated-by-space-and-minus-sign)
    - [footnotes](#footnotes)
    - [Molecules](#molecules)
  - [TODOs](#todos)
    - [Reading out loud](#reading-out-loud)
      - [By machine](#by-machine)
      - [By humans](#by-humans)
    - [Read and play](#read-and-play)
    - [Index or concordance](#index-or-concordance)
    - [Vocal assistant for proof reading](#vocal-assistant-for-proof-reading)
    - [Page numbers!](#page-numbers)
    - [Spellchecker](#spellchecker)
    - [makefile](#makefile)
    - [programming for geezers](#programming-for-geezers)

## General

### TOC

I need a table of contents for this kind of file as it grows and becomes unwieldy...

... and I can't find a working TOC generator!

Markdown All in One by Yu Zhang seems to be good

### Format

The best thing I found to start making a readable document is to convert to Markdown.
This requires very little change, mostly adding some blank lines, and presto! the justification happens on its own.

### Chapters

This is what I found to do page breaks, such as to start new chapters:

```html
<div style="page-break-after: always;"></div>
```

Trick found here:

https://stackoverflow.com/questions/22601053/pagebreak-in-markdown-while-creating-pdf

## _La Peste_

### Duplicate lines

Lines are sometimes duplicated, corresponding to page breaks in the PDF. This should be easily corrected by program, as it's unlikely there are intentionally repeated lines in the text.

Used this:

    perl -ne 'print if $_ eq "\n" || $_ ne $prev; $prev = $_' < lapeste.md > foo 

### Missing hyphens

When words are hyphenated for a line break in the PDF, the hyphen disappears in the text, and the two parts are stuck together. Correcting this requires tedious spotting of all occurrences of such line-ending hyphens in the PDF and adding them by hand back in the text.

Actually many such cases may be automatically found, because such lines are longer than normal, but since it's proportional-width characters, there's no such thing as a standard line length.

### Closing quotes wrong?

maybe not

Start with « and end with » unless multiple paragraphs then end all but last paragraph with ”... Need to check if this is a rule.

### Special paragraph breaks

At the beginning of every section, the first paragraph has more space after it than the usual paragraphs.

And there are cases where this happens inside the text, for example:

> C’était ce genre d’évidence ou d’appréhensions, en
tout cas, qui entretenait chez nos concitoyens le sentiment
de leur exil et de leur séparation.

Need to deal with this somehow, with extra markup?

for now marked with

    <div id="space" style=""></div>

### Generating HTML etc.

This nice blog post taught me stuff about using Markdown in VS Code (snippets! Ctrl-Space link) and led me to installing a bunch of stuff, extension for lintin Markdown, Pandoc, Pandoc extension, TexLive for PDF

https://thisdavej.com/build-an-amazing-markdown-editor-using-visual-studio-code-and-pandoc/

Commandline `pandoc` works better, see "footnotes" section below.

### Mme

M superscript me

## _Ignition!_

### First look

The text has some similar issues to _La Peste_, some different.

Two immediately obvious different ones:

1. extra space at the end of every line
2. chapter headers of each page mixed in the text, should be removed.

Both of these chould be easily correctable with a little program.

#### Extra space

Got 1. done with:

```bash
perl -pe 's/[ \t]+$//' ignition.md > foo
```

#### Hyphenated words

Another one is hyphenated words.

```bash
perl -pe 's/-\n$//' ignition.md > foo
```

Uh, nope, because of number ranges and things like "1000-pound" and "16-faced".
So let's ignore hyphenated digits, and deal with merging "1000=pound" and the like later.

```bash
perl -pe 's/(?<!\d)-\n$//' ignition.md > foo
```

#### Chapter headers and page numbers separating pages

Identify these headers of two kinds:

* \n{4} [even page number] Ignition (book title) \n{3}
* \n{4} [chapter title] \n{3} [odd page number] \n{2}

The corresponding regex would be... a PITA, ugh, the OCR did random stuff
with more patterns than listed above.

Five search-and-replaces seem to have done the job:

```bash
perl -0007 -pe 's/\n+\d+ Ignition\n+/\n/gm' ignition.md >foo

perl -0007 -pe 's/\n\n+(How It Started|Peenemunde and JPL|The Hunting of the Hypergol . . .|. . . and Its Mate|Peroxide — Always a Bridesmaid|Halogens and Politics and Deep Space|Performance|Lox and Flox and Cryogenics in General|What Ivan Was Doing|“Exotics”|The Hopeful Monoprops|High Density and the Higher Foolishness|What Happens Next)\n+\d+\n+/\n/gm' foo > foo2

perl -0007 -pe 's/\n\n+\d+\n+(How It Started|Peenemunde and JPL|The Hunting of the Hypergol . . .|. . . and Its Mate|Peroxide — Always a Bridesmaid|Halogens and Politics and Deep Space|Performance|Lox and Flox and Cryogenics in General|What Ivan Was Doing|“Exotics”|The Hopeful Monoprops|High Density and the Higher Foolishness|What Happens Next)\n+/\n/gm' foo2 > foo3

perl -0007 -pe 's/\n+(How It Started|Peenemunde and JPL|The Hunting of the Hypergol|and Its Mate|Peroxide — Always a Bridesmaid|Halogens and Politics and Deep Space|Performance \d|Lox and Flox and Cryogenics in General|What Ivan Was Doing|“Exotics”|The Hopeful Monoprops|High Density and the Higher Foolishness|What Happens Next).*\n+/\n/gm' foo3 > foo4

perl -0007 -pe 's/\n+(\d \d+ |\d+\n+|)Ignition\n+/\n/gm' foo4 > foo5
```

### Photos

Also, this book has photos. Need to look at including them.

### Layout help

The Internet Archive, where the text comes from, also has an easy-to-read visual version of the book, useful for copyediting.

https://archive.org/details/ignition_201612/

Note: I downloaded the PDF, but to prevent the two-page display from being off-by-one, use the option in Adobe Acrobat Reader DC: 

> View, Page Display,<br>
> Show Cover Page in Two Page View.

### em dash vs en dash?

Looks like the OCR produces both kinds, probably should be only one kind.

### dash separated by space, and minus sign

— should be surrounded by spaces in most cases.
Except when it should be a minus.

Some searches for auto replacement:

```bash
perl -ne 'print if /—/' ignition.md
# grep has the advantage of colorized matches
grep -E '[^ ]—' ignition.md
grep -E '—[0-9]' ignition.md
grep -E '— [0-9]' ignition.md
```

Not sure it was worth the time, but this command fixed 30 or so temperatures:

```bash
perl -pi -E '$s=$_;$x = s/— ([0-9])[ ]?([0-9]?)[ ]?([0-9])?[ ]?([.0-9]*)°/ -$1$2$3$4°/g; if ($x) { s/  / /g }' ignition.md
```

Hmm... can I use Perl to do an interactive search and replace?...

This old `replace_string` program "Copyright by Tilo Sloboda,  created 08 June 94" looks promising:
https://github.com/tilo/replace_string

### footnotes

there's a Markdown extended format for footnotes, but not well-supported out of the box?

This works though

    pandoc ignition.md > ignition.html 

### Molecules

need to search for all molecule patterns, then replace, `mol.pl` is a start.

## TODOs

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

### Index or concordance

Might be fun and easy to add an index. Not sure how useful though.

### Vocal assistant for proof reading

Reads out loud first words of every paragraph, for someone to follow as they check a printed copy.

### Page numbers!

I've regretted this on Kindle and other e readers (all of them?):
not keeping the old style page count.

What page am I on? This is not antiquated, it's still useful, for reference.
Percentages are barbaric. Maybe some day we will get there,
but for now a page number of a given edition is still a nice thing to keep and preserve.

So I need a way to keep that info in the Markdown...

### Spellchecker

Hmm could use a Markdown spellchecker... Is Code Spell Checker good enough? No.

### makefile

Should have a "build" process for generating HTML, checking, publishing, and whatever else.

Of course makefiles are uncool now, what should I use?

### programming for geezers

IDEA: should make a "programming for geezers: 

* tired: make; wired: webpack or whatnot
* tired: Emacs, wired: VS Code