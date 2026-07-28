---
title: Submit
layout: page
---

[&larr; Go home](/)

Submit to the 1kB Club. All source code is [here](https://git.sr.ht/~bt/1kb-club)

1. Run your website through [Debugbear's URL Scanner](https://www.debugbear.com/test/website-speed)
2. Get your **Bytes total** number under the **Network** heading
3. [Submit a patch](https://lists.sr.ht/~bt/1kb-club-devel)

When patching, edit the main `_data/sites.yml` file and include your own website like so:

```
- domain: 1kb.your.website
  size: 628
```

Don't worry about where you place this new addition inside of `_data/sites.yml`. This will be automatically reordered once pushed to `master`.
