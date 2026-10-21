---
name: testing
description: Use when running, fixing or writing tests.
---

# Testing methodology

## Failures

A failing test that surfaces a real bug is a signal to be kept until the bug is
fixed, not something to be weakened to get the test-suite artificially green; see [../../rules/tests.md].

## Golden output

Be careful not to automatically overwrite old golden output, as this may
accidentally mark incorrect behaviour as golden. Review re-generated golden
files to avoid this slipping through.
