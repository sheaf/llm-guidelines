---
paths:
  - "**/*.hs"
  - "**/*.hs-boot"
  - "**/*.c"
  - "**/*.h"
  - "**/*.cmm"
  - "**/*.css"
  - "**/*.js"
  - "**/*.nix"
---

# Documentation

Documentation is not an afterthought. It is one of the main steps in producing
high quality code. The act of writing documentation provides a powerful
opportunity to revisit the structure of the code: something that is difficult
to document clearly invites rethinking the code, /not/ compensating by writing
long and complex documentation.

## Significance

Comments (in particular long ones) indicate that something subtle/noteworthy is
going on in the code.
A long comment full of routine information that is obvious from a quick glance
at the code gives completely the wrong impression and one starts squinting
"yes OK but why are you saying all this"?

Comments should provide additional insights that cannot be trivially
reconstructed from glancing at the code: justification for a design, tradeoffs,
performance measurements, pointers to technical papers or a Wikipedia page, or a
quick reminder of something that is only obvious to an expert.

## Maintenance

Every comment has to be kept in sync with the code it describes. Two cases
where that upkeep is rarely worth it:

  - Code under active iteration: each change would invalidate the documentation.
    Keep it minimal and write the real documentation once the dust settles.
  - Tests, which need at most a quick statement of what they test, usually best
    left as a single link to a bug tracker.

## Style

Comments (including Haddocks) should be direct, explaining exactly what they are
attached to.

If the comment gestures at the concept through its relationships ("is used to...", "so that X can..."), it is wrong.

Comments are read in isolation; a sentence that can only be understood by
re-reading what came before it is too compressed: repeat omitted words rather
than leaving them implied. Likewise, Haddocks are not read in source
order, so never write documentation like:

```hs
-- | <some docs>
foo :: ...

-- | The same, but with <some other property>
foo2 :: ...
```

nor:

```hs
-- | Wrong: this documentation is written for the three things below but only
-- applies to the first.
bar1 :: ...
bar2 :: ...
bar3 :: ...
```


## Locality

Documentation must be /local/ (both spatially and temporally):

  - Temporal locality: the documentation should describe the /current/ state of
    the code:
      - it should not be a diff against past history nor speculate about the future;
      - it should not refer to any private conversations nor internal planning documents;
      - it should stand on its own and make sense independently to anyone else
        reading the code.
  - Spatial locality: there should be a /single source of truth/ for any piece
    of functionality. Basic smoke test: if the documentation could become false
    when editing far-away code that isn't /obviously/ coupled to the current
    location, it must be moved, reworked or removed.
    Do not document downstream behaviour on a particular function (e.g.
    "this function is used by ABC to do XYZ") unless there is a critical
    inter-dependence: this unnecessarily couples a function with its consumers
    and silently bitrots when those consumers change.

See also [notes.md#Notes] for genuinely cross-cutting observations, to be used
sparingly.
 

## Haddocks vs comments

Haddocks and code comments serve two different purposes and target different
audiences:

### Haddocks as API documentation

API documentation is for end-users and should use Haddock syntax.

Document a /contract/: what a consumer needs to know, free of internal details.
This should be short (high information density), with the types doing the heavy
lifting – if they don't, perhaps a refactor is necessary.

Document top-level functions and types, pushing documentation into individual
function arguments, data constructors and record fields when possible.
For example, instead of "the third argument is ...", directly document the third
argument using -- ^ syntax. This is both clearer to readers and easier to
maintain.

A Haddock comment is not in the business of justifying an implementation
decision; that belongs as a normal comment or in a [Note](notes.md).

### Comments for maintainers

Internal comments are for understanding and maintaining the codebase.

Strive to write code that doesn't need separate documentation; the structure of
the problem and the clarity of the code itself should suffice.

Comments are a last resort for explaining unavoidable subtleties or key linkage.


## External facts

A comment that states a fact about the world outside (a library's behaviour,
a tool's limitation, a measurement) must provide the means to verify this fact.
A reference to a primary source (technical paper, Wikipedia), or a measurement
that can be re-run, both qualify. "This bang pattern reduces allocations by 5%
in T12345" does not: the baseline is gone and nothing can be re-measured.

Before writing "we do X because Y does Z", find where Z is guaranteed: a
specification, documented behaviour, or an invariant the code enforces.

  - If Z is guaranteed but the guarantee is undocumented, document it upstream.
  - If Z is merely what Y happens to do, the preferred fix is to change Y.
    Failing that, the comment records a limitation being worked around, in the
    form "until Y does W", not "because Y does Z".
