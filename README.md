# Zenodo Metadata Validator 🛡️

![img/zenodo-json-validator.png](img/zenodo-json-validator.png)

> 🚀 Ensure your metadata is ready for archiving!

This GitHub Action validates your `.zenodo.json` file against the official Zenodo schema. No more broken uploads or missing creator names! We've vendored the schema 📦 here, and also allow you to provide your own. ☁️

## 🛠️ How to use it in your Pipeline

Add this sparkle to your `.github/workflows/validate.yml`:

```yaml
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 🛡️ Validate Zenodo Metadata
        uses: vsoch/zenodo-validator@main 
        with:
          path: '.zenodo.json'
```


## 💻 Running it locally

> ...for the rebels 🎸

Want to check your JSON before you even commit? Build the container and run it:

```bash
# 🏗️ Build the magic box
docker build -t zenodo-validator .

# 🪄 Run the spell
docker run --rm \
  -v $(pwd):/github/workspace \
  -e GITHUB_WORKSPACE=/github/workspace \
  -e INPUT_PATH=.zenodo.json \
  -e INPUT_SCHEMA_PATH=/schema.json \
  -e INPUT_ERROR_FORMAT=text \
  zenodo-validator
```

The above also works with:

```bash
make
make validate
```

## 🎁 Inputs

| Input | Description | Default |
| :--- | :--- | :--- |
| `path` 📍 | Where is your `.zenodo.json`? | `.zenodo.json` |
| `error_format` 🎨 | `text`, `json`, or `pretty-json` | `text` |

---

## 📄 License


DevTools is distributed under the terms of the MIT license.
All new contributions must be made under this license.

See [LICENSE](https://github.com/converged-computing/cloud-select/blob/main/LICENSE),
[COPYRIGHT](https://github.com/converged-computing/cloud-select/blob/main/COPYRIGHT), and
[NOTICE](https://github.com/converged-computing/cloud-select/blob/main/NOTICE) for details.

SPDX-License-Identifier: (MIT)

LLNL-CODE- 842614

MIT. Go forth and do science! 🔬🧬🥂

**Maintained by [@vsoch](https://github.com/vsoch)** 🌟
