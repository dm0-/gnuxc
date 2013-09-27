#!/bin/bash

alias objcopy=$(rpm -E %gnuxc_objcopy)
alias objdump=$(rpm -E %gnuxc_objdump)
alias nm=$(rpm -E %gnuxc_nm)
alias readelf=$(rpm -E %gnuxc_readelf)

. $(rpm -E %_rpmconfigdir/find-debuginfo.sh)
