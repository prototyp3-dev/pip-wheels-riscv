#!/bin/bash

WHEELS_DIST="../wheels"
WHEELHOUSE="./wheelhouse"

SEPARATOR="-"

mtime_param=
separator=$SEPARATOR
wheelhouse=$WHEELHOUSE
wheels_dist=$WHEELS_DIST
name_pattern_param=
add_dir=
perform_move=
run=

print_help() {
    echo "Usage: $0 OPTIONS
Transfer wheels from wheelhouse dir to organized dist wheels.

Arguments
  -r, execute the operation
  -a, also create directories when not present
  -x, also move files to ideal path
  -m, mtime to find files
  -n, filename pattern to find
  -w, wheelhouse path
  -d, dist wheels path
  -s, separator to 

Examples:
  $0 -a -x
  $0 -a -r
  $0 -w ./my_wheels -d /var/www/wheels -s cp -n numpy*
"
}

while getopts "m:d:w:s:n:axrh" flag; do
    case $flag in
        m)
        mtime_param="-mtime -$OPTARG"
        ;;
        w)
        wheelhouse=$OPTARG
        ;;
        d)
        wheels_dist=$OPTARG
        ;;
        s)
        separator=$OPTARG
        ;;
        n)
        name_pattern_param="-name $OPTARG"
        ;;
        a)
        add_dir=1
        ;;
        x)
        perform_move=1
        ;;
        r)
        run=1
        ;;
        h)
        print_help
        exit 0
        ;;
        ?)
        echo Invalid option: $flag
        exit 1
        ;;
    esac
done

file_list=$(find $wheelhouse -type f $mtime_param $name_pattern_param -print)


for file in $file_list; do
    filename=$(basename $file)
    dist_dir=$(echo "$filename" | cut -d$separator -f1)

    path="$wheels_dist/$dist_dir/$filename"
    found_path=$(find $wheels_dist -type f -name $filename -print)

    # Check if the file exists and is a regular file
    if [ ! -f "$path" ]; then
        if [ -n "$found_path" ]; then
            if [ -n "$perform_move" ]; then
                if [ -n "$add_dir" ] && [ ! -d "$wheels_dist/$dist_dir" ]; then
                    echo "mkdir -p $wheels_dist/$dist_dir"
                    [ -n "$run" ] && mkdir -p $wheels_dist/$dist_dir
                fi
                echo "mv $found_path $path"
                [ -n "$run" ] && mv $found_path $path
            fi
        else
            if [ -n "$add_dir" ] && [ ! -d "$wheels_dist/$dist_dir" ]; then
                echo "mkdir -p $wheels_dist/$dist_dir"
                [ -n "$run" ] && mkdir -p $wheels_dist/$dist_dir
            fi
            echo "cp $file $path"
            [ -n "$run" ] && cp $file $path
        fi
    fi
done