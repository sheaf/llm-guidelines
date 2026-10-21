---
paths:
  - "**/*.hs"
  - "**/*.hs-boot"
---

# Style guide

## Existing style

Try to preserve the existing style of the codebase you are contributing to.

## Abbreviations

Generally avoid acronyms and abbreviations as they obfuscate the meaning and
make it harder for newcomers to make sense of it. Only use them when clear
from context or it would be extremely tedious to repeat the full expression.

## Import grouping

In import declarations, group each import by the package that defines them,
like so:

```hs
-- base
import Control.Monad
  ( when )

-- primitive
import Data.Primitive.MutVar
  ( MutVar )

-- vector
import qualified Data.Vector.Unboxed.Mutable as Unboxed
  ( MVector )
```

Sort these groups alphabetically, except that you should put the group for
imports from the current package last.

## TypeApplications

Prefer using `TypeApplications` over inline type signatures, as this conveys
more intent. For example, `try @MyException ...` is MUCH clearer than code such
as

```hs
do x <- try ...
   case x of
     Just (y :: MyException) -> ...
```

which has some spooky action-at-a-distance: need to read ahead to figure out
what the initial `try` is doing.

## TypeAbstractions

Use `TypeAbstractions`, in particular for `runST` blocks
`runST \ @s -> ... (code with type signatures that mention s) ...`

## DuplicateRecordFields

Use the DuplicateRecordFields extension liberally. Record field names don't need
prefixes for name disambiguation. To avoid "ambiguous record field" issues,
prefer record syntax such as `f (MyRec { dupFldName = x }) = ...`, or using
the module system `myRec { ModQual.dupFldName = x }`.

## DerivingStrategies

Use `DerivingStrategies`, e.g.

```hs
newtype Level = Level Int
  deriving stock Show
  deriving newtype ( Eq, Ord )
```

## Literal syntax

Use `NegativeLiterals` and `LexicalNegation`; no parentheses needed around
negative literals, e.g. `fn -3`.

Floating point literals that happen to be integers do not need a decimal point,
e.g. `x :: Float; x = 0` is perfectly fine (unlike in C). Rely on types to
make it clear that it is a floating-point value, not on the decimal point.

Use `0b001101`, `0xFF0000`, `12_3456` syntax when appropriate to clarify the
meaning of a literal.

## Module qualification

Liberally use module qualification to disambiguate. Don't use short acronyms.
A good example is:

```hs
import qualified Data.Vector.Unboxed as Unboxed ( Vector )
import qualified Data.Vector.Unboxed as Unboxed.Vector ( (!), map )
```

Module qualification makes sense to avoid name clashes when using external
packages (`containers`, `vector` etc), but also within a single package to
clearly demarcate where different components of the codebase come together.

## Unicode

When including Unicode characters in source code, use the actual characters
(e.g. `"➤"`) and not their encodings (e.g. `"\10148"`). The encoding is
unreadable at a glance and imposes a cognitive overhead.
