---
paths:
  - "**/*.hs"
  - "**/*.hs-boot"
---

# Notes

For genuinely cross-cutting observations where a high-level overview is
necessary (and only then!), use a GHC-style Note that is referenced at all
relevant sites. The Note becomes the source of truth that explains all the
moving parts, and the references to it allow us to keep it in sync when the
code changes. Do not overuse these!

If a Note seems necessary, that is first a prompt to restructure the code so it
isn't, and then something to discuss before writing.

A Note full of incidental information goes stale the moment anything changes,
and a misleadingly outdated Note is worse than none.

Pre-existing Notes (e.g. in GHC or handwritten by the user)
should never be rewritten without checking in with the user:
see § Ownership in the general guidelines.
