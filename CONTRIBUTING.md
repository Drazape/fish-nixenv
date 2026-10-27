# Source Code
Contribution to the primary codebase doesn't have any special instructions.  
The [user documentation](https://drazape.github.io/fish-subAbbr/ "The documentation for both the users and distributors") is available to learn how to make and contributing packages

# Git Branching
The `develop` bookmark is used for the following:
- Basing commits upon, downstream
- Pushing revisions to, upstream

# Documentation
The following sections provide guidance on contributing to the project's documentation
## Spelling Mistakes
This repository uses the [GitHub Spellcheck Action](https://github.com/marketplace/actions/github-spellcheck-action "Action on GitHub Marketplace") automatically catches all spelling mistakes found in Markdown files.
If a spelling “mistake” found is intentional (that happens often), add the word to `.wordlist.txt` at the root of the repository.
## Generation
The documentation site is generated using [Zensical](https://zensical.org/ "Official site: a modern static site generator designed to simplify building and maintaining project documentation")
## Style
We follow the [Google Documentation Style Guidelines](https://developers.google.com/style "Editorial guidelines for writing clear and consistent technical documentation for an audience of software developers and other technical practitioners")
### Deviations
We take some liberty to move away from the guidelines.  
The following sections describe the major deviations we made.
#### Curled Quotation
In contrast to the straight quotation marks used in the Google Style (`"`), we instead use curly quotation marks (`“` & `”`) outside code-blocks.
#### Line Breaks
The Google style prohibits the use of line breaks; consequently, starts of new lines is limited to a new paragraph.  
In contrast, we extensively use line breaks to make it easier for readers to skip sentences.
#### Endashes
Use endashes wherever they seem to be the best choice—don't use hyphens instead.
