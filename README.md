# Local Conan Recipes

This directory is a Conan 2 `local-recipes-index`. Its layout follows the ConanCenter index shape:

```text
recipes/<package>/config.yml
recipes/<package>/all/conanfile.py
recipes/<package>/all/conandata.yml
recipes/<package>/all/test_package/
```

Consuming projects can use this repository as a top-level `conan-recipes/` submodule or checkout.
The `cmake-conan` provider in `project-config` automatically registers that checkout as a
recipes-only local Conan remote when it is present.

Keep recipes close to ConanCenter style so packages can be moved upstream later with minimal
rewriting.
