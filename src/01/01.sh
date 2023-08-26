#!/bin/bash

source "$(pwd)/utils/utils.sh";
source "$(pwd)/utils/validation.sh";

arg_length=$#
abs_path="/Users/anrdeysuvorov/projects/LinuxMonitoring_2/src/01/test";
dir_number=3;
dir_letters="abcdef";
files_number=2;
file_letters="abcdef.ghi";
file_size=100; #в кб

mem_lower_limit=32500 #в Мб

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




function file_generator() {
    # починить условие валидации
    if [[ ! -d $abs_path ]]; then
        echo "ERROR: $abs_path doesn't exist";
        exit -1;
    fi;
    if [[ ! -rxw $abs_path ]]; then
        echo "ERROR: $abs_path cannot be read/write, change permissions";
        exit -1;
    fi;
   

    local file_log_path=${abs_path}/file_log;
    touch $file_log_path;
    local dir_log_path=${abs_path}/dir_log;
    touch $dir_log_path;
    clear_file $file_log_path;
    clear_file $dir_log_path;
    
    local current_dir=$abs_path;
    cd $current_dir;

    local current_dir="";
    local current_file="";
    local creation_time="";
    local bytes_size=$(mul_float $file_size 1000);
    for (( i = 0; i < dir_number; i++ )); do
        current_dir=$(dir_name_composer);
        mkdir $current_dir;
        creation_time=$(get_creation_time $current_dir);
        cd $current_dir;
        printf '%s %s\n' "$(pwd)" "$creation_time" >> $dir_log_path;

        for (( j = 0;  $mem_lower_limit <= $(get_free_space) && j < $files_number; j++ )) {
            current_file=$(file_name_composer);
            truncate -s $bytes_size $current_file;
            printf '%s %s %s\n' "$(pwd)/$current_file" "$(get_creation_time $current_file)" "$file_size" >> $file_log_path;
        }
    done;

    cd $abs_path;
    printf "files:\n$(cat $file_log_path)\ndirectories:\n$(cat $dir_log_path)" > log;

    rm -rf $file_log_path $dir_log_path;
}

function main() {
    arg_validator;
    file_generator;
}



main;