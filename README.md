# gaming-graphics-test-suite

To run the tests:

```
./src/run-all.sh
```

Optional environment variables:

```
LIBGL_ALWAYS_SOFTWARE=1  # Force llvmpipe for OpenGL even if a GPU is present.
VK_LOADER_DRIVERS_SELECT='*lvp*'  # Force lavapipe for Vulkan even if a GPU is present.
```
