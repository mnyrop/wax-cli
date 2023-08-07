
`wax build collection demo --simple-images --iiif --pages`

```rb
config  = Wax::Config.load options['config']
builder = Wax::Builder.new config

collection = Wax::Collection.new name, config
collection.validate!
items = collection.load_data
builder.build data=items strategies=collection.build_strategies
```

steps

1. load _config.yml
2. load collection-specific config
3. check if .wax-cache for collection exists
    - if not: initialize one
4. check if wax.json exists
    - if not: initialize one
5. parse collection @items from config, records, assets, & dictionary opts
6. for each item: # update cache
    - set bool item assets_have_changed?
    - update wax-cache with new SHAs
7. for each item: # simple images
   - if item assets_have_changed?
      + for each asset:
        - delete target derivatives
        - remove ref from item.assets.simple_derivatives
    - see if expected target derivatives exist (via variants config)
      + if not: generate them and add info to item.assets.simple_derivatives
    - write results to wax.json
8. for each item: # iiif
    - if item assets_have_changed?
      + for each asset:
        - delete iiif info.json
        - remove ref from item.assets.iiif_derivatives
    - see if expected target derivative exists (info.json should be sufficient)
      + if not: generate all derivatives and add info to item.assets.iiif_derivatives
    - regenerage manifest.json
    - write results to wax.json
9. for each item: # pages
    - write markdown page with yaml front matter