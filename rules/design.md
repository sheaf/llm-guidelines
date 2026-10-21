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

## Duplication

Re-use library functionality instead of reinventing your own. Take the time
to look up the documentation of libraries you are using so that you make
the most of them, including recent additions to those libraries.

Every line of code has a maintenance cost and an intellectual overhead.
It is ALWAYS preferable to re-use existing libraries when possible. If the
library we are using is missing a key piece of functionality, it's much
better to submit a change to that library instead of working around the
problem locally.

Shared logic should be commoned up as much as possible instead of having
duplicated code paths (which can go out of sync, each harbouring its own
set of bugs).

Try to reduce the maintenance burden by removing code that is no longer
needed, as well as removing outdated comments. Make sure to follow
Chesterton's fence: do not remove something (even a comment) unless you know
why it was there and are certain it can be deleted (e.g. no external
consumer depends on it).

Use `deriving` as much as possible to avoid writing boilerplate. This is
particularly relevant for boilerplate-heavy code such as `Vector.Unbox`.

## Modularity

Modularity means conceptual layers with real boundaries, not just splitting
up a module into separate files.



Avoid entangling functions. If the caller of a function needs to do
something complicated (either to call the function or to handle the result),
when feasible this should be enforced in some way, e.g. by using the
type system to avoid hidden invariants, or by designing an API and only
exposing the functionality through this API.



A function taking many arguments of the same type is generally a bad sign,
as it means the function's type signature doesn't communicate its semantics
very well. Consider creating a record type to hold the arguments (so that
individual fields can have their own field name and Haddocks), or making
some of the types into type synonyms, newtypes or new datatype declarations
to distinguish their meaning. If that would be senseless boilerplate, at
least make sure that the individual arguments are given Haddocks:

```hs
foo :: Int  -- ^ maximum number of iterations
    -> Int  -- ^ stride
    -> IO ()
```



Organise the code logically: a change in a function (e.g. adding a new
argument) naturally ripples downstream to its consumers via the type system,
and similarly for changes in datatypes (via pattern match warnings).

Structure the code to leverage this, so that a refactor naturally ripples
through the codebase. Changes that do not propagate in this manner indicate
a mis-design (e.g. "now you have to to call some function of type `IO ()`"
as opposed to "the only way I can update my code is by calling this specific
function of type `A -> B` to get a value of type `B`).

## Generality

Implement general and architecturally sound solutions to problems (e.g. from
the research literature or reference implementations), **especially** when it
involves rethinking significant parts of the existing code.
Avoid piling on workarounds or taking shortcuts when it would be preferable to
overhaul existing code (even if it's in a library we depend on).
NB: this isn't an invitation to transform targeted one-line changes into
large amounts of new code. Always prefer refactoring/rewriting existing
code over writing completely new implementations/codepaths.



Don't reach for quick-and-dirty fixes that end up cluttering the codebase and
add cognitive overhead. For example, a simple function such as:

```hs
typecheckModule :: Module GhcRn -> TcM (Module GhcTc)
```

should never be changed to:

```hs
typecheckModule :: Module GhcRn -> TcM (Module GhcTc, MyRandomStuff1, MyRandomStuff2)
```

just to accommodate the needs of a new feature or bugfix.



Where a class of bugs is recurrent, this invites a rethinking of the overall
architecture, instead of sprinkling fixes that require discipline and
maintenance across the codebase.

## Naming

Identifiers should be self-descriptive, taking into account whether the
identifier is expected to be used qualified or unqualified.

`containers`, `vector` are good references: we use `Map.insert`
and `Boxed.Vector.map`, not `Map.insertMap` nor `Boxed.Vector.mapVector`.
Conversely, for a module imported unqualified, names should stand on
their own, e.g. `GHC.Core.Coercion` is imported unqualified, so it defines `mkSymCo` and `coercionKind`, not `mkSym` or `getKind` etc.

Think about what occurrences of the identifier will look like:
`data Stretch` from `Data.Time` appearing unqualified in a type signature
elsewhere is mystifying; either it should be qualified or it should be
something like `TimeSpan`.

Don't duplicate the type name in the field selector name, e.g. prefer

```hs
data Song = Song { duration :: Seconds }
```

and we can use `Song.duration` if disambiguation is needed.



Use consistent nomenclature. For example, mixing `Instant`, `Moment`,
`Timestamp` for a single concept will send readers hunting for a difference
that isn't there. The existence of such types also indicates a genuine
data representation problem that should be solved by de-duplicating.
