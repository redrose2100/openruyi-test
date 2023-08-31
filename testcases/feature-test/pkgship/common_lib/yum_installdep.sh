function get_installdep_by_yum() {
    pkg=$1
    dep=$(get_singledep $pkg)
    echo "level1 = "${dep[@]}
    for data1 in ${dep[@]}; do
        level=$(get_singledep $data1)
        echo "level == "$level
        if [[ $level =~ "perl" ]]; then
            echo "depend package =============== "$data1
            break
        fi
        dep=(${dep[@]} ${level[@]})
    done
}

function get_singledep() {
    pkg=$1
    level=$(yum deplist $pkg | grep provider | cut -d ':' -f 2 | sort | uniq)
    if [[ "$level"x != ""x ]]; then
        echo $level
        return 0
    else
        return 1
    fi
}

get_installdep_by_yum coreutils-8.32-2.oe1.aarch64
