---
paths:
  - "**/test/**"
  - "**/tests/**"
  - "**/testsuite/**"
---

# Writing tests

## Failures

Do not craft test cases that work around existing bugs in the code base,
nor weaken tests just to get them to pass. If there are issues in the code base,
it is EXPECTED that certain tests should fail. This gives a clear signal for
when the bugs get fixed.

## Standards

Testing code has generally weaker requirements: it's OK to use some basic
idioms like lists as data structures if it makes the testing code simpler
(performance is usually not a great concern).
