# wax_cli :: spec planning doc

## contents

- [commands](#commands)
- [site config](#site-config)
  - [fullest sample config](#fullest-sample-config)
  - [simplest sample config](#simplest-sample-config)
- [collection dictionary](#collection-dictionary)
  - [sample dictionary file](#sample-dictionary-file)
- [user story](#user-story)

## commands

```bash
  wax --version, -v  
  wax build               # see user story below for description of behavior
    wax build collection NAME
    wax build collections
    wax build item COLLECTION_NAME ITEM_ID
  wax clobber
    wax clobber collection NAME
    wax clobber collections
    wax clobber item COLLECTION_NAME ITEM_ID
  wax lint
    wax lint collection NAME
    wax lint collections
```

## site config  

### fullest sample config
*(with explicit/redundant defaults & optional values)*

```yaml
collections:
  demo:
    output: true # needs to be true for jekyll to render pages to _site
    assets: 'collections/demo/assets' # path to folder of assets (images) relative to `_data` dir; default is `collections/<collection-name>/assets`
    records: 'collections/demo/records.csv' # path to file of metadata records relative to `_data` dir; default is `collections/<collection-name>/records.csv`
    dictionary: 'collections/demo/dictionary.yml' # path to dictionary yaml file relative to `_data` dir; default is `collections/<collection-name>/dictionary.yml`
    build: # steps to run/invoke with `wax build`
      simple_images: 
        variants: # default is banner: 1140 and thumb: 400
          - banner: 1140
          - thumb: 400
      iiif:
        scale_factors: [] # need to figure out default
      pages: 
        layout: item.html # item.html is default; that layout should exist in the theme and use dictionary.yml to know what to show
      search: 
        index: '/search/indexes/demo.json' # '/search/indexes/<collection_name>.json' is the default
```

### simplest sample config
*(still works! just using implicit defaults. "convention vs configuration" etc. etc.)*

```yaml
collections:
  demo:
    output: true
    build:
      simple_images:
      iiif:
      pages: 
      search:
```
## collection dictionary

A collection `dictionary.yml` file is OPTIONAL.

By default, all values will appear in each output with a label that is the same as the `key`. E.g, if a csv column header is `_date` that's how it'll be labeled on a page or in a IIIF manifest.

If a `dictionary.yml` file *is* specified for the collection, the configuration in `metadata` will be added to the record parsing process.

Keys not configured in a `dictionary.yml` file will *still* get built with the key value used as the label. Keys need to be explicitly *excluded* from the outputs—in other words, wax-v2 treats metadata as *opt-out* whereas wax-v1 treats it as *opt-in*.

### sample dictionary file

e.g., `collections/demo/dictionary.yml`
``` yml
metadata:
  - label: 'Item ID'
    key: 'pid'
  - label: 'Label'
    key: 'label'
  - label: 'Tags'
    key: 'tags'
    array_split: ';' # only needed if records are in CSV original format (as opposed to JSON, which can natively handle arrays and nested hashes)
  - key: 'is_digitized'
    exclude_from:
      all: true # makes ones below redundant, but just to show options
      # pages: true
      # iiif: true
      # search: true
```

## user story
1. I use `wax-kit` boilerplate repository template to make my own repo and clone it.
2. I run `bundle install`, which pulls in `wax_theme` and `wax_cli` via remote ruby gems.
3. I run `bundle exec wax clobber demo`
4. I replace the demo collection data with my own `assets`, `records.csv`, and `dictionary.yml` that live in the `wax` folder within the project root:
    ```sh 
    .
    ├── Gemfile
    ├── README.md
    ├── _config.yml
    ├── _site
    └── source # the jekyll site source lives tidied here
        └── _data # the un-processed wax input data lives here
            └── demo
                ├── assets
                ├── dictionary.yml
                └── records.csv
    ```
    ~~>
    ```sh 
    .
    ├── .wax-cache
    ├── Gemfile
    ├── README.md
    ├── _config.yml
    ├── _site
    └── source # the jekyll site source lives tidied here
        └── _data
            └── my_collection # renamed!
                ├── assets # replaced!
                ├── dictionary.yml # replaced!
                └── records.csv # replaced!
    ```
5. I update my repo's config to reference my new collection `my_collection`:
    ```yaml
    collections:
      demo:
        output: true
        build:
          simple_images:
          iiif:
          pages: 
          search:
    ```
    ~~>
    ```yaml
    collections:
      my_collection: # renamed! that's it!
        output: true
        build:
          simple_images:
          iiif:
          pages: 
          search:
    ```
6. I run `bundle exec wax lint my_collection` to check for any errors & warnings with my collection data & configuration. (e.g., missing id, invalid csv, unallowed column header/key, etc.)
7. I run `bundle exec wax build collection my_collection` which will run *all* the build tasks specified in the collection `build` config (in this case `simple_images`, `iiif`, `pages` and `search`) for the jekyll site to use.  It will also create/update the `.wax-cache` with information about what's been done to enable md5/diff-based partial rebuilds.
8. Later, if I want to (re)build a specific output for the collection (e.g., the pages), I can run the command with a flag, e.g.,
    ```sh
    bundle exec wax build collection my_collection --pages
    ```
    or
    ```
    bundle exec wax build collection my_collection --search
    ```
    which will build only that output type
    see:
    ```sh
      bundle exec wax build collection --help

      Usage:
        wax build collection NAME

      Options:
                  [--search], [--no-search]                # If true, builds a search index for the collection.
                  [--iiif], [--no-iiif]                    # If true, builds IIIF resources.
                  [--pages], [--no-pages]                  # If true, builds markdown page for each item.
                  [--simple-images], [--no-simple-images]  # If true, builds simple image derivatives.

      Build the wax collection named NAME
    ```
9. I can then build and serve my site with jekyll normally:
    ``` sh
    bundle exec jekyll serve
    ```
