# sphinx

## 4.2.0

### Install

```bash
pip3 install sphinx
pip3 install myst-parser
pip3 install sphinxcontrib-mermaid
pip3 install sphinx-rtd-theme
```

### Usage

In your working directory

```bash
sphinx-quickstart
```

```bash
vi conf.py
```

> ```python
> extensions = [
>     'myst_parser',
>     'sphinxcontrib.mermaid',
>     'sphinx_rtd_theme',
> ]
>
> html_theme = 'sphinx_rtd_theme'
> ```

```bash
make html
```
