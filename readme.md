# LLM wrangling guidelines

This repository contains my personal guidelines for LLMs. I handwrote every
single one, because I want to impose my own standards on LLM output and avoid a
regression to the mean arising from LLMs writing their own guidelines. A hook
ensures the files are never edited by an LLM.

## Installation

**Requirements**: `bash`, `jq`, `realpath` (`coreutils`).


`./install.sh` symlinks the guideline documents into the places Claude expects
to find them, and registers hooks into `.claude/settings.json`.