#!/bin/bash
# Leo Gutierrez

readonly background_jobs=7
declare -A pidinfo
pids=""
n=0

wait_for_jobs() {
    local -r pids="${1}"
    local p
    for p in ${pids}; do
        if wait ${p}; then
            echo "Done ==> ${pidinfo[${p}]}"
        else
            echo "Failed ===>  ${pidinfo[${p}]}"
        fi
    done
}

while read build_file; do
    if grep --silent 'pom\.xml$' <<< "${build_file}"; then
        mvn --quiet --file "${build_file}" clean > /dev/null 2>&1 &
        last_pid=${!}
        pids+=" ${last_pid}"
        pidinfo[${last_pid}]="${build_file}"
    elif grep --silent 'build\.gradle$' <<< "${build_file}"; then
        gradle --quiet --build-file "${build_file}" --no-daemon clean 2>&1 &
        last_pid=${!}
        pids+=" ${last_pid}"
        pidinfo[${last_pid}]="${build_file}"
    fi

    ((n++))
    if ((n >= background_jobs)); then
        ((n = 1))
        wait_for_jobs "${pids}"
        pids=""
    fi
done < <(locate --ignore-case pom.xml build.gradle | grep --extended-regexp '(pom\.xml|build\.gradle)$')

wait_for_jobs "${pids}"

exit 0