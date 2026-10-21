---
name: documentation
description: Use to finalise documentation (e.g. before committing).
---

# Writing documentation as a final pass

Documentation should be written once per change, after the design settles:
see [../../rules/docs.md#defer-documenting].

## Procedure

1. Review the change to assess what documentation needs to be updated or
   added, whether Haddock (user-facing) or internal.

   This will include `TODO(doc)` markers, but do not expect those to be
   exhaustive.

2. For each putative piece of documentation, decide what needs to be (re-)written,
   if anything at all, as per the standard of [../../rules/docs.md].

   In particular, this means that changes to pre-existing comments will
   require explicit agreement from the user (unless they are mechanical fixes).

3. Hand over the changes. This could be as individual fixup! commits, or as
   unstaged changes, as per the user's preference.

