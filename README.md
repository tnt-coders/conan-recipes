# Local Conan Recipes

This directory is a Conan 2 `local-recipes-index`. Its layout follows the ConanCenter index shape:

```text
recipes/<package>/config.yml
recipes/<package>/all/conanfile.py
recipes/<package>/all/conandata.yml
recipes/<package>/all/test_package/
```

`cmake/LocalConanRecipesProvider.cmake` registers this checkout as a recipes-only
`local-recipes-index` remote for the active `CONAN_HOME` before delegating to a consuming project's
`cmake-conan` provider.

Consuming projects can use this repository as a submodule or as a normal sibling checkout. Point
`CMAKE_PROJECT_TOP_LEVEL_INCLUDES` at the provider:

```json
"CMAKE_PROJECT_TOP_LEVEL_INCLUDES":
    "${sourceDir}/conan-recipes/cmake/LocalConanRecipesProvider.cmake"
```

The provider defaults to `${CMAKE_SOURCE_DIR}/project-config/cmake-conan/conan_provider.cmake`.
Set `LOCAL_CONAN_RECIPES_CMAKE_CONAN_PROVIDER` when a project keeps `cmake-conan` elsewhere.

Set `LOCAL_CONAN_RECIPES_ALLOWED_PACKAGES` to a semicolon-separated list such as `libebur128/*`
when a project wants this recipes index restricted to specific packages.

Keep recipes close to ConanCenter style so packages can be moved upstream later with minimal
rewriting.
