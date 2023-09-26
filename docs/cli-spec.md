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
  wax lint # is wax validate better ???
    wax lint collection NAME
    wax lint collections
```

## site config  

### fullest sample config
*(with explicit/redundant defaults & optional values)*

```yaml
search:
  site:
    index: 'wax/search/site.json' # default if empty is 'wax/search/NAME.json' so 'wax/search/site.json' here
    full_site: true
  demo: # this does the exact same thing as demo.build.search below! the search config here really makes sense for indexes that have multiple collection and/or full_site scope, but you could configure an index just for one collection (e.g. demo) up here too.
    index: 'wax/search/demo.json'
    collections:
      - demo

collections:
  demo:
    output: true # needs to be true for jekyll to render pages to _site
    assets: 'collections/demo/assets' # path to folder of assets (images) relative to `_data` dir; default is `collections/<collection-name>/assets`
    records: 'collections/demo/records.csv' # path to file of metadata records relative to `_data` dir; default is `collections/<collection-name>/records.csv`
    dictionary: 'collections/demo/dictionary.yml' # path to dictionary yaml file relative to `_data` dir; default is `collections/<collection-name>/dictionary.yml`
    build: # steps to run/invoke with `wax build`
      simple_images: 
        variants: # default is full_image: 1140 and thumbnail: 400
          - full_image: 1140
          - thumbnail: 400
      iiif:
        scale_factors: [] # need to figure out default
      pages: 
        layout: item.html # item.html is default; that layout should exist in the theme and use dictionary.yml to know what to show
      search: 
        index: '/wax/search/demo.json' # default if empty is 'wax/search/<collection-name>.json' so 'wax/search/demo.json' here
```

### simplest sample config
*(still works! just using implicit defaults. "convention vs configuration" etc. etc.)*

```yaml
search:
  site:
    full_site: true
  demo:
    collections: [demo]

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
pid:
  label: 'Item ID'
label:
  label: 'Label'
tags:
  label: 'Tags'
  array_split: ';' # only needed if records are in CSV original format (as opposed to JSON, which can natively handle arrays and nested hashes)
is_digitized:
  exclude: true # keep field out of resulting derivatives (e.g., pages, iiif manifest)
```
