
Commands

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
  wax index
    wax index aggregate
    wax index all
    wax index collection NAME
    wax index each
  wax lint
    wax lint collection NAME
    wax lint collections
```

Config 

```yaml
collections:
  demo:
    output: true # needs to be true for jekyll to render pages to _site
    wax:
      assets: 'assets' # REQUIRED(?) – path to folder of assets (images) relative to wax/<name>
      records: 'records.csv' # REQUIRED - path to file of metadata records relative to wax/<name>
      dictionary: 'dictionary.yml' # REQUIRED(?) – path to dictionary yaml file relative to wax/<name>
      build: # steps to run/invoke with `wax build`
        simple_images: # default is true if `simple_images` key exists
          variants: # default is banner: 1140 and thumb: 400
            banner: 1140
            thumb: 400
        iiif:
          enabled: true # default is true if `iiif` key exists
          extract_existing: true # default is false
          scale_factors: [] # need to figure out default
          exclude: [] # default metadata is from dictionary.yml, uses eveything by default
        pages: 
          enabled: true # default is true
          layout: item.html # item.html is default; that layout should exist in theme and use dictionary.yml
        search: # default is true if `search` key exists
          exclude: [] # default metadata is from dictionary.yml, uses eveything by default
          index: '/search/demo-index.json'
```