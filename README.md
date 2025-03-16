## TODO

- Gravestones (or something similar)
  - kinda done? not perfectly integrated with accessories tho :(
- Backpacks (potentially)
- have less structures maybe? idk if there are too many
- maybe rethink terrain generation

## Download latest release

The modpack is currently automatically built using a reaaaally crappy github action, but it works for now^^

[download link](https://nightly.link/feathecutie/modpack/workflows/blank/main)

## Building/Exporting

### `.mrpack` (Modrinth)

```sh
packwiz mr export
```

### `.zip` (Curseforge)

```sh
packwiz cf export
```

## Adding a mod

### From Modrinth

```sh
packwiz mr add <slug/name/id of mod (e.g. "create")>
```

### From Curseforge

```sh
packwiz cf add <slug/name/id of mod (e.g. "create")>
```

Check out the [packwiz documentation](https://packwiz.infra.link/) for more
