# Custom Entrypoint Scripts

Add executable `.sh` scripts here to run at container startup.

Scripts run in alphabetical order before the main application starts.
Use numeric prefixes to control order (e.g., `00-first.sh`, `10-second.sh`).

## Example

```bash
#!/bin/bash
# 00-custom-setup.sh
echo "Running custom initialization..."
```

Make sure scripts are executable: `chmod +x 00-custom-setup.sh`
