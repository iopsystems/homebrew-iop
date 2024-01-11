# IOP Systems Homebrew Repository

This repository has homebrew formulae for SystemsLab and other related software
developed by IOP Systems.

## How do I install these formulae?

`brew install iopsystems/iop/<formula>`

Or `brew tap iopsystems/iop` and then `brew install <formula>`.

## Installing from source

Some of the formulae in this repo do not have public source code (most notably,
systemslab). If you want these to be available on different OSes please raise
an issue and we'll add it to CI.

> ### For internal users
> You'll need to set the `HOMEBREW_GITHUB_API_TOKEN` environment variable to
> a github token that has access to the relevant repositories before you can
> build from source.
>
> If using a class access token then you'll need to enable the various `repo`
> scopes in order to access private github repos.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
