<h1 id="header" align="center">
  <img src=".github/assets/nix-snowflake-colours.svg" width="128px" height="128px" />
  <br>
  Firn
</h1>

<div align="center">
   My ever-evolving NixOS flake for use on all my systems
</div>

<div align="center">
  <br/>
    <a href="#Overview">Overview</a><br/>
    <a href="#Goals">Goals</a><br/>
    <a href="#Credits">Credits</a><br/>
  <br/>
</div>

## Overview

Firn serves as the central declarative configuration for my fleet of NixOS machines. It is structured as a monorepo, ensuring that changes can be propagated across all systems or isolated to specific ones with ease.

### Structure
- **`flake.nix`**: The compilation entry point. It defines dependencies (inputs) and the resulting system configurations (outputs).
- **`hosts/`**: Machine-specific configurations. Each directory here corresponds to a nix host, containing its hardware scan (`hardware-configuration.nix`) and unique overrides (`default.nix`).
- **`modules/`**: The building blocks of the system.
  - **`core/`**: The baseline configuration defaults applied to every machine (e.g., general security policies, networking basics) — these options can be overridden by a specific host if needed.
  - **`features/`**: Individual units of functionality (e.g., a specific desktop environment, service, or hardware support).
  - **`roles/`**: Collections of features that define a system's purpose (e.g., `workstation` or `laptop`).
- **`lib/`**: Any custom library functions to streamline system creation and reduce boilerplate.

## Goals

[Synaptic Standard]: https://github.com/llakala/synaptic-standard

The design of Firn follows a specific set of principles to keep the codebase clean and manageable:

- **Pure NixOS**: I explicitly avoid `home-manager` and heavy abstractions like `flake-parts`. User environments are managed through standard NixOS `users.users` modules to keep the dependency graph simple and the evaluation fast.
- **Minimal Boilerplate**: Adding a new host should be a trivial task. The heavy lifting is done by custom modules and roles, allowing host files to remain small and declarative.
- **Synaptic-ish Structure**: The organization is inspired by the **[Synaptic Standard]**, adapting its logical separation of concerns (Core vs Features vs Roles) without adhering to it dogmatically.
- **Self-Documenting Code**: Variable naming and module structure are chosen to be intuitive and detailed comments added where necessary. The codebase alone should be enough to understand most functionality.


## Credits
A significant amount of inspiration, code, and input is directly taken from [Raf's](https://github.com/NotAShelf) flake: [NotAShelf/nyx](https://github.com/NotAShelf/nyx/), with many parts of the implementation closely following the structure and logic laid out there. I would like to thank him for all his hard work and contributions to the Nix community.
