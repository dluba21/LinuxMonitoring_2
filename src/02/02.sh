#!/bin/bash

source "$(pwd)/utils/utils.sh";
source "$(pwd)/utils/validation.sh";

# config ---->
abs_path="/Users/anrdeysuvorov/projects/LinuxMonitoring_2/src/02/test";
dir_letters="abcdef";
file_letters="abcdef.ghi";
file_size=100; #Mb
mem_lower_limit=28500; # <--- the task implies that the free memory must be completely
# <----                #  filled, but for security reasons, a restriction has been 
                       # introduced, any value can be set here (Mb).

bytes_size=$(mul_float $file_size 1000);
file_log_path=${abs_path}/file_log;
dir_log_path=${abs_path}/dir_log;
current_tmp_dir="";

function get_free_space() {
    echo $(df -m / | awk '{print $4}' | sed -n '2p');
}

function get_rand_name() {
    local letters=$1;
    local word="${letters:0:1}${letters:0:1}${letters:0:1}${letters:0:1}";

    for (( i = 0; i < ${#letters}; i++ )); do 
        local letter=${letters:i:1};
        local num_of_letters=$(randnum 1 3);
        for (( j = 0; j < $num_of_letters; j++ )); do
            word+=$letter;
        done;
    done;
    echo $word;
}

function get_number_before_kb() {
    for (( i = 0; i < ${#file_size}; i++ )) {
        if [[ ! ${file_size:i:1} =~ [0-9]{1} ]]; then
            break ;
        fi;
    }
    echo ${file_size:0:i};
}


function get_filename_part() {
    local file_name=$1;
    local dot_position=$(get_dot_position $file_name);
    if [[ $2 == "FIRST_PART" ]]; then
        echo ${file_name:0:$dot_position};
    elif [[ $2 == "SECOND_PART" ]]; then
        echo ${file_name:$(expr $dot_position + 1):${#file_name}};
    else
        echo "ERROR: incorrect input for \"get_filename_part\" function";
        exit -1;
    fi;
}


function file_name_composer() {
    local string=$(get_rand_name $(get_filename_part $file_letters "FIRST_PART"));
    string+=".";
    string+=$(get_rand_name $(get_filename_part $file_letters "SECOND_PART"));
    string+="_$(date +%d%m%y)";
    echo $string;
}

function dir_name_composer() {
    local string=$(get_rand_name $dir_letters);
    string+="_$(date +%d%m%y)";
    echo $string;
}

function create_dir_and_file() {
    local current_dir=$1;
    local dir_gen_path="$current_dir/$(dir_name_composer)";
    local file_gen_path="$dir_gen_path/$(file_name_composer)";

    mkdir "$dir_gen_path";
    creation_time=$(get_creation_time $dir_gen_path);
    printf '%s %s\n' "$dir_gen_path" "$creation_time" >> $dir_log_path;

    echo "gen_dif is: $dir_to_generate";
    truncate -s $bytes_size $file_gen_path;
    printf "$file_gen_path is created!\n";

    current_tmp_dir=$dir_gen_path;
    printf '%s %s %s\n' $file_gen_path "$(get_creation_time $file_gen_path)" "$file_size" >> $file_log_path; 
  
}

function traverse_dir_recursively() {
    local current_dir=$1;
    if [ $mem_lower_limit -le $(get_free_space) ]; then
        create_dir_and_file $current_dir;
    fi;
   
    for sub_dir in "$current_dir"/*; do
        if [[ ! $mem_lower_limit -le $(get_free_space) ]]; then
            exit 0;
        fi;
        if [[ -dxr $sub_dir && $sub_dir != "bin" && $sub_dir != "sbin" && $sub_dir != $current_tmp_dir ]]; then
            echo "current dir: $current_dir";
            echo "sub dir: $sub_dir";
            echo "created dir $created_dir_path";
            traverse_dir_recursively "$sub_dir";
        fi;
    done;
}


function file_generator() {
    echo 'ok';
    if [[ ! -d $abs_path ]]; then
        echo "ERROR: $abs_path doesn't exist";
        exit -1;
    fi;
    if [[ ! -rxw $abs_path ]]; then
        echo "ERROR: $abs_path cannot be read/write, change permissions";
        exit -1;
    fi;

    touch $file_log_path;
    touch $dir_log_path;
    clear_file $file_log_path;
    clear_file $dir_log_path;
    
    counter=0;
    while [ $mem_lower_limit -le $(get_free_space) ]; do
        traverse_dir_recursively $abs_path;
        echo "one more iter $counter";
        # sleep 10;
        counter=$(($counter + 1));
        # echo "aa";
    done;

    cd $abs_path;
    printf "files:\n$(cat $file_log_path)\ndirectories:\n$(cat $dir_log_path)" > log;
    rm -rf $file_log_path $dir_log_path;
}


function main() {
    arg_validator;
    file_generator;
}

input_yn="";

printf "Do you want to use input values?\nEnter: yes/no (y/n)\n";
read input_yn;
if [ $input_yn == 'y' ]; then
    abs_path="/";
    dir_letters=$1;
    file_letters=$2;
    file_size=$3;
fi;
main;