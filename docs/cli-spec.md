# wax_cli :: spec planning doc

## contents

- [commands](#commands)
- [full config](#full-config)
- [simplest config](#simplest-config)
- [user story](#user-story)

## commands

```bash
  wax --version, -v  
  wax build
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

## full config  
*(with explicit/redundant defaults & optional values)*

```yaml
collections:
  demo:
    output: true # needs to be true for jekyll to render pages to _site
    wax:
      assets: '/wax/demo/assets' # REQUIRED(?) – path to folder of assets (images); default is `/wax/<collection-name>/assets`
      records: '/wax/demo/records.csv' # REQUIRED - path to file of metadata records; default is `/wax/<collection-name>/records.csv`
      dictionary: '/wax/demo/dictionary.yml' # REQUIRED(?) – path to dictionary yaml; default is `/wax/<collection-name>/dictionary.yml`
      build: # steps to run/invoke with `wax build`
        simple_images: # default is true if `simple_images` key exists
          variants: # default is banner: 1140 and thumb: 400
            banner: 1140
            thumb: 400
        iiif:
          enabled: true # default is true if `iiif` key exists
          scale_factors: [] # need to figure out default
        pages: 
          enabled: true # default is true if `pages` key exists
          layout: item.html # item.html is default; that layout should exist in the theme and use dictionary.yml to know what to show
        search: 
          enabled: true # default is true if `search` key exists
          index: '/search/indexes/demo.json' # '/search/indexes/<collection_name>.json' is the default
```

## simplest config
*(still works! just using implicit defaults. "convention vs configuration" etc. etc.)*

```yaml
collections:
  demo:
    output: true
    wax:
      build:
        simple_images:
        iiif:
        pages: 
        search:
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
    ├── src # the jekyll site source lives tidied here
    └── wax # the un-processed wax input data lives here
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
    ├── src 
    └── wax 
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
        wax:
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
        wax:
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
    see:
    ```sh
      bundle exec wax build collection --help

      Usage:
        wax build collection NAME

      Options:
                  [--search], [--no-search]                # If true, builds a search index for the collection.
                  [--clobber], [--no-clobber]              # If true, clobbers the collection to reset before running.
                  [--iiif], [--no-iiif]                    # If true, builds IIIF resources.
                  [--pages], [--no-pages]                  # If true, builds markdown page for each item.
        --simple, [--simple-images], [--no-simple-images]  # If true, builds simple image derivatives.

      Build the wax collection named NAME
    ```
9. I can then build and serve my site with jekyll normally:
    ``` sh
    bundle exec jekyll serve
    ```
