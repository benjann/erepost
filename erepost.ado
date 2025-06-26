*! version 1.0.3  26jun2025  Ben Jann

prog erepost, eclass
    version 8.2
    syntax [anything(equalok)] [, cmd(str) noEsample Esample2(varname) REName ///
        Obs(passthru) Dof(passthru) PROPerties(passthru) ///
        NOB NOV se drop(str) * ]
    if "`nob'"!="" local nov nov
    if "`esample'"!="" & "`esample2'"!="" {
        di as err "only one of noesample and esample() allowed"
        exit 198
    }
// parse [b = b] [V = V]
    if `"`anything'"'!="" {
        tokenize `"`anything'"', parse(" =")
        if `"`7'"'!="" error 198
        if `"`1'"'=="b" {
            if `"`2'"'=="=" & `"`3'"'!="" {
                local b `"`3'"'
                confirm matrix `b'
            }
            else error 198
            if `"`4'"'=="V" {
                if `"`5'"'=="=" & `"`6'"'!="" {
                    local v `"`6'"'
                    confirm matrix `b'
                }
                else error 198
            }
            else if `"`4'"'!="" error 198
        }
        else if `"`1'"'=="V" {
            if `"`4'"'!="" error 198
            if `"`2'"'=="=" & `"`3'"'!="" {
                local v `"`3'"'
                confirm matrix `v'
            }
            else error 198
        }
        else error 198
    }
//backup existing e()'s
    if "`esample2'"!="" {
        local sample "`esample2'"
    }
    else if "`esample'"=="" {
        local efunctions: e(functions)
        if `:list posof "sample" in efunctions' {
            tempvar sample
            gen byte `sample' = e(sample)
        }
        else local esample noesample
    }
    local emacros: e(macros)
    if `"`drop'"'!="" {
        Drop emacros `"`emacros'"' `"`drop'"'
    }
    local emacros: subinstr local emacros "_estimates_name" "", word
    if `"`properties'"'!="" {
        local emacros: subinstr local emacros "properties" "", word
    }
    foreach emacro of local emacros {
        local e_`emacro' `"`e(`emacro')'"'
    }
    local escalars: e(scalars)
    if `"`drop'"'!="" {
        Drop escalars `"`escalars'"' `"`drop'"'
    }
    if `"`obs'"'!="" {
        local escalars: subinstr local escalars "N" "", word
    }
    if `"`dof'"'!="" {
        local escalars: subinstr local escalars "df_r" "", word
    }
    foreach escalar of local escalars {
        tempname e_`escalar'
        scalar `e_`escalar'' = e(`escalar')
    }
    local ematrices: e(matrices)
    if "`b'"!="" local nob
    else if "`nob'"=="" & `:list posof "b" in ematrices' {
        tempname b
        mat `b' = e(b)
    }
    if "`v'"!="" local nov
    else if ("`nov'"=="" | "`se'"!="") & `: list posof "V" in ematrices' {
        tempname v
        mat `v' = e(V)
    }
    if "`nob'`nov'"!="" { // make sure e(properties) will be updated
        local emacros: subinstr local emacros "properties" "", word
    }
    local bV "b V"
    local ematrices: list ematrices - bV
    if `"`drop'"'!="" {
        Drop ematrices `"`ematrices'"' `"`drop'"'
    }
    foreach ematrix of local ematrices {
        tempname e_`ematrix'
        matrix `e_`ematrix'' = e(`ematrix')
    }
// rename
    if "`b'"!="" & "`v'"!="" & "`rename'"!="" { // copy colnames from b
        mat `v' = `b' \ `v'
        mat `v' = `v'[2..., 1...]
        mat `v' = `b'', `v'
        mat `v' = `v'[1..., 2...]
    }
// option se
    if "`se'"!="" {
        if "`v'"!="" {
            tempname e_se
            matrix `e_se' = vecdiag(`v')
            forv i = 1/`=colsof(`e_se')' {
                matrix `e_se'[1,`i'] = sqrt(`e_se'[1,`i'])
            }
            local ematrices: list ematrices | se
            if "`nov'"!="" local v
        }
    }
// post results
    if "`v'"!="" & "`b'"=="" {
        di as err "cannot set {bf:e(V)} without {bf:e(b)}"
        exit 499
    }
    if "`esample'"=="" {
        eret post `b' `v', esample(`sample') `obs' `dof' `properties' `options'
    }
    else {
        eret post `b' `v', `obs' `dof' `properties' `options'
    }
    foreach emacro of local emacros {
        eret local `emacro' `"`e_`emacro''"'
    }
    if `"`cmd'"'!="" {
        eret local cmd `"`cmd'"'
    }
    foreach escalar of local escalars {
        eret scalar `escalar' = scalar(`e_`escalar'')
    }
    foreach ematrix of local ematrices {
        eret matrix `ematrix' = `e_`ematrix''
    }
end

program Drop
    args nm list drop
    local newlist
    foreach el of local list {
        local hit 0
        foreach p of local drop {
            if match("`el'", `"`p'"') {
                local hit 1
                continue, break
            }
        }
        if `hit' continue
        local newlist `newlist' `el'
    }
    c_local `nm' `newlist'
end
