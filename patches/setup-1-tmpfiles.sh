#!/bin/bash
# This is a partially implemented alternative to systemd-tmpfiles.
set -e
shopt -s nullglob
export LC_ALL=C

# Determine values that can be used in later substitutions.
machine_id= # Unsupported
boot_id= # Unsupported
host_name=$(hostname)
kernel_release=$(uname -r)

# Enable processing of boot-only files, if requested.
test "x$1" = x--boot && shift && boot=1 || boot=

# Determine tmpfiles.d configuration file precedence.
declare -A conffiles
for dir in /usr/lib/tmpfiles.d /run/tmpfiles.d /etc/tmpfiles.d
do
        for file in $dir/[!.]*.conf
        do
                conffiles[${file##*/}]=$file
        done
done

# Process the configuration files after sorting them lexicographically.
declare -A tmpfiles
IFS=$'\n' declare -a confnames=($(IFS=$'\n' ; echo "${!conffiles[*]}" | sort))
for name in "${confnames[@]}"
do
        while read type path mode uid gid age argument extra
        do
                # Skip blank/comment lines.
                test -n "$type" -a "x${type:0:1}" != 'x#' || continue

                # See if this path was logged, or log it otherwise.
                test -n "${tmpfiles[$path]}" &&
                echo 1>&2 \
                    "Warning: Ignoring \"$path\" in ${conffiles[$name]}" \
                    "since it is already defined by ${tmpfiles[$path]}." &&
                continue ||
                tmpfiles[$path]=${conffiles[$name]}

                # Skip boot-only lines if the boot option was not given.
                test "x${type: -1}" != 'x!' -o -n "$boot" || continue

                # Prepare the path.
                test "x${path:0:1}" != x/ -o ${#path} -le 1 &&
                echo 1>&2 \
                    "Warning: Ignoring \"$path\" in ${conffiles[$name]}" \
                    "since it doesn't appear to be an absolute path." &&
                continue ||
                path=${path//%m/$machine_id}
                path=${path//%b/$boot_id}
                path=${path//%H/$host_name}
                path=${path//%v/$kernel_release}
                path=${path//%%/%}

                # Unset any skipped optional fields.
                test "x$mode" != x- || mode=
                test "x$uid" != x- || uid=
                test "x$gid" != x- || gid=
                test "x$age" != x- || age=

                # Now create each file type as needed.
                case "${type%\!}" in
                    f)  test -e "$path" || (echo -n "$argument" > "$path" && chown ${uid:-0}:${gid:-0} "$path" && chmod ${mode:-0644} "$path") ;;
                    F)  echo -n "$argument" > "$path" && chown ${uid:-0}:${gid:-0} "$path" && chmod ${mode:-0644} "$path" ;;
                    w)  test ! -f "$path" || (echo -en "$argument" > "$path" && chown ${uid:-0}:${gid:-0} "$path" && chmod ${mode:-0644} "$path") ;;
                    d)  test -e "$path" || install -dm ${mode:-0755} -o ${uid:-0} -g ${gid:-0} "$path" ;;
                    D)  test ! -d "$path" || rm -rf "$path" ; install -dm ${mode:-0755} -o ${uid:-0} -g ${gid:-0} "$path" ;;
                    p)  ;;
                    p+) ;;
                    L)  test -e "$path" || ln -s "${argument:-/usr/share/factory/${path##*/}}" "$path" ;;
                    L+) ln -fs "${argument:-/usr/share/factory/${path##*/}}" "$path" ;;
                    c)  ;;
                    c+) ;;
                    b)  ;;
                    b+) ;;
                    C)  test -e "$path" || (cp -a "${argument:-/usr/share/factory/${path##*/}}" "$path" && chown -R ${uid:-0}:${gid:-0} "$path" && chmod -R ${mode:-a=rX,u+w} "$path") ;;
                    x)  ;;
                    X)  ;;
                    r)  rm -fd "$path" ;;
                    R)  rm -fr "$path" ;;
                    z)  ;;
                    Z)  ;;
                    *)  echo 1>&2 "Warning: Ignoring \"$path\" in ${conffiles[$name]} because \"$type\" is an invalid type." && continue ;;
                esac
        done < "${conffiles[$name]}"
done
