#!/usr/bin/env nu

let previous_hash: string = git show HEAD:pack.toml | from toml | get index.hash
let current_hash: string = open pack.toml | get index.hash
if $previous_hash != $current_hash {
  let previous_version: string = git show HEAD:pack.toml | from toml | get version
  let current_pack_toml = open pack.toml
  if (semver compare $previous_version $current_pack_toml.version | into int) >= 0 {
    $current_pack_toml | inc -p version | save -f pack.toml
  }
} 
