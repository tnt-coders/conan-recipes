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

## Auto-registered Conan remote

When the `cmake-conan` provider in `project-config` finds a `conan-recipes/` checkout at the
consuming project's top level, it registers it as a Conan remote named `local_conan_recipes`
during every CMake configure. The registration uses `--recipes-only --type local-recipes-index
--force --allowed-packages <name>/*` for every package directory present here, so removing or
renaming a recipe directory implicitly narrows the allow list on the next configure.

Running `conan remote remove local_conan_recipes` to debug is fine, but the next configure will
re-register it. To stop auto-registration set `-DCONAN_LOCAL_RECIPES_AUTO_REGISTER=OFF`.
