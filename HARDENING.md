<!-- markdownlint-disable -->

# Hardening Report: veracode--veracode-uploadandscan-action/v0.0.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **veracode--veracode-uploadandscan-action/v0.0.1** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b): the entrypoint script evaluates its arguments, which come from action inputs. entrypoint.sh builds a shell script by putting the Docker args straight into echo strings and then runs it (line 276: `./runJava.sh`), so the args go through a shell exactly as with eval. Line 93 writes `-filepath $filepath` with no quotes, so shell metacharacters in inputs.filepath (`;`, `|`, `$(...)`, backticks) become commands in runJava.sh. The other inputs are only wrapped in escaped double quotes (for example `-version \"$version\"`, `-appname \"$appname\"`, `-sandboxname \"$sandboxname\"`, `-teams \"$teams\"`). Those quotes don't stop `$(...)` or backticks from running, and an embedded `"` can break out of them. The `version` input defaults to github.* context, and the input values come from whatever workflow calls the action. Fix: run java directly from entrypoint.sh with quoted arguments ("$filepath" and so on) or build an argument list with `set --`, and stop generating and running runJava.sh.

Locations:

- `entrypoint.sh:93`
- `entrypoint.sh:276`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Rewrote entrypoint.sh. It no longer writes runJava.sh and runs it. Instead it builds the Veracode wrapper's arguments one by one as positional parameters (set -- "$@" -flag "$value") and runs `java -jar VeracodeJavaAPI.jar "$@"` itself. Every value, including filepath, is quoted, so `;`, `$(...)`, backticks and embedded quotes reach java as plain text and are never run. All checks, error messages and flag choices match upstream, including upstream's mapping of `selected` to -selectedpreviously. The script stays POSIX sh and uses `=` instead of `==`. One more change: upstream printed runJava.sh with `cat`, which showed vid/vkey in the log. The new script prints a short notice instead, with the credentials masked. filepath used to be unquoted, so the shell split it on spaces and expanded globs. It is now passed as a single argument, which fits the wrapper's single-path -filepath. Dockerfile and action.yml args are unchanged.

