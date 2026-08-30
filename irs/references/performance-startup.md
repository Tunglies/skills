# Performance, Startup, And Render

- Define the symptom, runtime boundary, baseline, and required evidence before choosing a shape.
- Confirm work was removed, deferred, or reduced rather than shifted earlier or into another critical path.
- Check unrelated I/O, parsing, initialization, subscriptions, timers, rendering, and singleton construction for newly eager work.
- Cover relevant direct-entry, mounted, fallback, transition, and disabled paths.
- Justify caches, seeded state, cross-module initialization APIs, or ownership changes against a smaller local shape.
- Re-measure the real target runtime; browser, mock, static, or code-shape evidence alone does not prove runtime performance.
