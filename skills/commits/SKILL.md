---
name: commits
description: Use when authoring or modifying commits.
---

# Guidelines about commits and commit messages

## Commit messages

### Purpose

The purpose of a commit message is to explain a set of changes at a high-level
way. It is /not/ an inventory of everything the commit does.
It should be useful to readers of the commit message: someone bisecting, cherry-picking, or reviewing.
"Fixes typo in comment in Blah.hs" is of no value to any reader.

It should also not dwell on the old mistake; at most it should quickly note the
old mistake before explaining the change. Focus on stating the correct behaviour
and explaining it.

### Context

The commit message should not assume the reader has the relevant context; indeed
it precisely should /provide/ the context the reader needs to make sense of the
changes it describes; see [../../rules/docs.md#Locality].

Avoid paraphrasing a complex code change: it won't make sense to people who
don't already know the code, and it will have no value for people who do.
Describe the idea the change implements, not the specific edits that enact
that change.


### Title

Good commit titles condense WHERE, WHAT & WHY into one line. Examples:

  "Register allocator: reload at same format as spill"

    WHERE: register allocation (GHC.CmmToAsm.Reg)
    WHAT: change spilling/loading to use the same format
    WHY: presumably because using different formats caused data loss
         (inferrable if you understand stack spilling/reloading)

  "Speed up hole fits with a quick pre-test"

    WHERE: the "valid hole fits" code in the typechecker
    WHAT: add a test that speeds it up
    WHY: for the evident performance gains
         (people will be aware hole fits are generally slow)

Sometimes it's not possible to condense all that in the title, so the body
should quickly move on to fill in the necessary context.

A poor commit title:

  Cmm: delete losing blocks in common block elimination

    WHERE: in common block elimination (GHC.Cmm.CommonBlockElim)
    WHAT/WHY: no idea. Common block elimination already does
              delete losing blocks, so this title says nothing.



## Commit contents

One logical change (or collection of interdependent changes) per commit, so
that individual changes can reviewed and backported independently.

Don't split up "add tests + fix the tests".
