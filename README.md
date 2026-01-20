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
    <a href="#Design-Philosophy">Design</a> |
    <a href="#Goals">Goals</a><br/>
    <a href="#The-Fleet">The Fleet</a><br/>
    <a href="#Credits">Credits</a><br/>
  <br/>
</div>

## Overview

Firn serves as the central declarative configuration for my fleet of NixOS machines. It is structured as a monorepo, ensuring that changes can be propagated across all systems or isolated to specific ones with ease.

## Design Philosophy

This configuration prioritizes **composition over monolithic profiles**. Instead of defining machines by rigid labels like "Workstation" or "Server", Firn describes them by *what they are* (Roles) and *what they can do* (Features).

> **A host is the sum of its roles and features.**

*   **Roles** answer "What is this machine's intent?": `interactive` (human use), `mobile` (laptop), `server` (headless), `compute` (VM host).
*   **Features** answer "What capabilities does it have?": `graphical`, `audio`, `shell`.

This approach ensures code is **composable**, **explainable**, and **reusable** across different environments like NixOS, WSL, and Darwin.

### Structure
- **`flake.nix`**: The compilation entry point. It defines dependencies (inputs) and the resulting system configurations (outputs).
- **`hosts/`**: Machine-specific configurations. Each directory here corresponds to a nix host, containing its hardware scan (`hardware-configuration.nix`) and unique overrides (`default.nix`).
- **`modules/`**: The building blocks of the system.
  - **`core/`**: The absolute minimum configuration defaults applied to every machine. Only universal settings live here.
  - **`policy/`**: Intentional defaults and global preferences (e.g., unfree software, tailscale, garbage collection, security policies).
  - **`features/`**: Opt-in units of functionality (e.g., `graphical/niri`, `audio/pipewire`, `network/`). Features are narrow and implementation-focused.
  - **`roles/`**: High-level machine identities (`interactive`, `server`, `mobile`, `compute`) that compose features to define a system's purpose.
- **`lib/`**: Helpers like `mkSystem` and `recursivelyImport` to streamline system creation and reduce boilerplate.

## The Fleet

| Name | Description | Type | Platform |
| :--- | :--- | :--- | :--- |
| **Platinum** | My daily driving desktop workstation boasting a Ryzen 7 7700 and 5060Ti. | `interactive`, `compute` | NixOS ● x86_64-linux |
| **Zinc** | A handy WSL2 setup for development work when I'm stuck on Windows. | `interactive` | WSL2 ● x86_64-linux |

## Goals

[Synaptic Standard]: https://github.com/llakala/synaptic-standard

The design of Firn follows a specific set of principles to keep the codebase clean and manageable:

- **Pure NixOS**: I explicitly avoid `home-manager` and heavy abstractions like `flake-parts`. User environments are managed through standard NixOS `users.users` modules to keep the dependency graph simple and the evaluation fast.
- **Minimal Boilerplate**: Adding a new host should be a trivial task. The heavy lifting is done by custom modules and roles, allowing host files to remain small.
- **Self-Documenting Code**: Variable naming and module structure are chosen to be intuitive and detailed comments added where necessary. The codebase alone should be enough to understand most functionality.


## Credits
A significant amount of inspiration, code, and input is directly taken from [Raf's](https://github.com/NotAShelf) flake: [NotAShelf/nyx](https://github.com/NotAShelf/nyx/), with many parts of the implementation closely following the structure and logic laid out there. I would like to thank him for all his hard work and contributions to the Nix community.
