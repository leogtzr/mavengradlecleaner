#!/bin/bash
# set -x

# declare -A build_tool=(["mvn"]="--file" ["gradle"]="--build-file")

# for tool in "${!build_tool[@]}"; do 
#     echo "${tool} - ${build_tool[${tool}]}"; 
# done

# readonly background_jobs=3
# n=0
# declare -A pidinfo
# pids=""

while read build_file; do
    # echo "Build file: ${build_file}"
    if grep --silent 'pom\.xml$' <<< "${build_file}"; then
        mvn --quiet --file "${build_file}" clean
        # last_pid=${!}
        # pids+=" ${last_pid}"
        # pidinfo[${last_pid}]="${build_file}"
    elif grep --silent 'build\.gradle$' <<< "${build_file}"; then
        gradle --quiet --build-file "${build_file}" --no-daemon clean
        # last_pid=${!}
        # pids+=" ${last_pid}"
        # pidinfo[${last_pid}]="${build_file}"
    fi

    # ((n++))
    # if ((n >= background_jobs)); then
    #     ((n = 1))
    #     for p in ${pids}; do
    #         if wait ${p}; then
    #             echo "Done ==> ${pidinfo[${p}]}"
    #         else
    #             echo "Failed ===>  ${pidinfo[${p}]}"
    #         fi
    #     done
    #     pids=""
    # fi
done < <(locate --ignore-case pom.xml build.gradle | grep --extended-regexp '(pom\.xml|build\.gradle)$' | sort | head -n50)

# for pid in "${!pids[@]}"; do 
#     echo "${pid} - ${pids[${pid}]}"; 
# done

exit 0
