# erepost
Stata module to repost the estimation results

`erepost` changes the b or V matrix of the current estimation results or changes
the declared estimation sample. `erepost` is similar to official `ereturn repost`.
However, `erepost` is allowed after estimation commands that do not post their
results using `ereturn post` (e.g. `logit`) and `erepost` can be used outside of
eclass programs.

To install the `erepost` package from the SSC Archive, type

    . ssc install erepost, replace

in Stata. Stata version 8.2 or newer is required.

---

Installation from GitHub:

    . net install erepost, replace from(https://raw.githubusercontent.com/benjann/erepost/master/)

---

Main changes:

    17apr2020
    - installation files added to GitHub distribution

    15jun2015
    - -rename- did not support factor variables; this is fixed
    - no longer copies e(_estimates_name); this makes sense since stored estimates
      will not be updated by -ereturn-

    30jul2007
    - properties(), obs(), and dof() now work correctly
    
    27jun2007
    - released on SSC