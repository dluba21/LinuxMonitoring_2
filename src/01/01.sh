#!/bin/bash


function atoi() {
     printf '%d' "'$1'";
}

function clear_file() {
     echo -n "" > $1;
}

function get_free_space() {
    echo $(df -m / | awk '{print $4}' | sed -n '2p');
}

function get_creation_time() {
    echo $(stat -t "%d-%m-%Y %H:%m:%S" $1 | awk '{print $9, $10}' | tr -d \");
}

function dir_name_validator() {
    if [[ ! $dir_letters =~ ^[A-Za-z]{1,7}$ ]]; then
        echo "ERROR: file name [$dir_letters] has not just chars";
        exit -1;
    fi;
}

function file_name_validator() {
    if [[ ! $file_letters =~ ^[A-Za-z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
        echo "ERROR: file name [$file_letters] doesn't match pattern *{1,7}.*{1,3}*";
        exit -1;
    fi;
}

function get_dot_position() {
    local string=$1;

    for (( i = 0; i < ${#string}; i++ )); do
        if [[ ${string:i:1} == "." ]]; then
            echo $i;
            return 0;
        fi;
    done;
    echo "ERROR: dot in filename wasn't found";
    exit -1;
}


function name_letters_validator() {
    
	if [[ ${#file_letters} -gt 7 ]]; then
        echo "ERROR: file name [$file_letters] length cannot be more than 7 digits"
        exit -1;
    fi;
    if [[ ${#dir_letters} -gt 7 ]]; then
        echo "ERROR: dir name [$dir_letters] length cannot be more than 7 digits"
        exit -1;
    fi;
    # echo $file_letters;
    # if [[ ! $file_letters =~ \b[\a-zA-Z]+\.[a-zA-Z]+\b ]]; then
    #     echo  "ERROR: file "
    # fi
    # if [[  ]]
    echo $dir_letters;
      if [[ ! $dir_letters =~ \b[a-zA-Z]+\b ]]; then
        echo  "ERROR: dir "
    fi

    # if [[ =~ ]]

}


function arg_validator() {
    if [[ $arg_length -ne 6 ]]; then
        echo "ERROR: script requires 6 args"
        exit -1;
    fi
    # name_letters_validator;
    # if 
    file_name_validator;
    
}






# $1 - нижняя граница $2 - верхняя
function randnum() {
    echo $(shuf -i $1-$2 -n 1);
}

# $1 - строка (я еще вводил фикс длину имен, но мне лень)
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
    # if [[ ! -d abs_path ]]; then
    #     echo "ERROR: $abs_path doesn't exist";
    #     exit -1;
    # fi;
   

    local file_log_path=${abs_path}/file_log;
    touch $file_log_path;
    local dir_log_path=${abs_path}/dir_log;
    touch $dir_log_path;
    # clear_file $file_log_path;
    # clear_file $dir_log_path;
    
    local current_dir=$abs_path;
    cd $current_dir;

    local current_dir="";
    local current_file="";
    local creation_time="";
    for (( i = 0; i < dir_number; i++ )); do
        current_dir=$(dir_name_composer);
        mkdir $current_dir;
        creation_time=$(get_creation_time $current_dir);
        cd $current_dir;
        printf '%s %s\n' $(pwd) $creation_time >> $dir_log_path;

        for (( j = 0;  $mem_lower_limit <= $(get_free_space) && j < $files_number; j++ )) {
            current_file=$(file_name_composer);
            truncate -s "${file_size}K" $current_file;
            printf '%s %s %s\n' "$current_dir/$current_file" "$(get_creation_time $current_file)" "$file_size" >> $file_log_path;
        }
    done;
}


arg_length=$#
abs_path="/Users/anrdeysuvorov/projects/LinuxMonitoring_2/src/01/test";
dir_number=30;
dir_letters="abcdef";
files_number=10;
file_letters="abcdef.ghi";
file_size=100; #в кб

mem_lower_limit=29700 #в Мб


# function file_name_composer() {
#     local string=$(get_rand_name $(get_filename_part "FIRST_PART" $file_letters));
#     string+=".";
#     string+=$(get_rand_name $(get_filename_part "SECOND_PART" $file_letters));
#     string+="_$(date +%d%m%Y)";
#     echo $string;
# }

# file_name_composer;
# get_rand_name "aavvgg";

# echo $abs_path;

file_generator;


# get_dot_position $file_letters;

# function get_dot_position() {
#     local string=$1;

#     for (( i = 0; i < ${#string}; i++ )); do
#         if [ ${string:i:1} == "." ]; then
#             echo $i;
#             break;
#         fi;
#         echo ${string:i:1};
#     done;
#     echo "ERROR: dot in filename wasn't found";
#     exit -1;
# }

# get_dot_position $file_letters;
# file_name_composer;
# dir_name_composer;