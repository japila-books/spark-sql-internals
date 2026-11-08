[private]
default:
    @just --list

[doc('Start Zensical dev server (live reload)')]
serve *args:
    uvx zensical serve {{ args }}
