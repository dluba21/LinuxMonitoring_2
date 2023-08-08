#!/bin/bash


function atoi() {
     printf '%d' "'$1'";
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
        local num_of_letters=$(randnum 1 10);
        for (( j = 0; j < $num_of_letters; j++ )); do
            word+=$letter;
        done;
    done;
    echo $word;
}


function get_filename_part() {
    local file_name=$1;
    local dot_position=$(echo $file_name | grep -aob '.' | grep -oE '[0-9]+');
    if [[ $2 -eq "FIRST_PART" ]]; then
        echo ${file_name:0:$dot_position};
    elif [[ $2 -eq "SECOND_PART" ]]; then
        echo ${file_name:$(expr $dot_position + 1):${#file_name}};
    else
        echo "ERROR: incorrect input for \"get_filename_part\" function";
        exit -1;
    fi;
}


function file_name_composer() {
    local string=$(get_rand_name $(get_filename_part "FIRST_PART" $file_letters));
    string+=".";
    string+=$(get_rand_name $(get_filename_part "SECOND_PART" $file_letters));
    string+="_$(date +%d%m%Y)";
    echo $string;
}

function dir_name_composer() {
    local string=$(get_rand_name $dir_letters);
    string+="_$(date +%d%m%Y)";
    echo $string;
}



function get_size_each_file() {
    
}

function file_generator() {
    if [[ ! -d abs_path ]]; then
        echo "ERROR: $abs_path doesn't exist";
        exit -1;
    fi;
    # local free_space=$(df -m / | awk '{print $4}' | sed -n '2p');
    touch ${abs_path}/file_log;
    local file_log_path=${abs_path}/file_log;
    touch ${abs_path}/dir_log;
    local dir_log_path=${abs_path}/dir_log;

    local dir_name=$(name_composer $dir_letters);
    local file_name_main=$(name_composer $(get_filename_part "FIRST_PART" $file_letters));
    local file_name_ext=$(name_composer $(get_filename_part "SECOND_PART" $file_letters));

    cd $abs_path;
    for (( i = 0; i < dir_number; i++ )); do
        mkdir 
    done;




}


arg_length=$#
abs_path=$1;
dir_number=$2;
dir_letters=$3;
files_number=$4;
file_letters=$5;
file_size=$6;

# echo $abs_path
# echo 
# arg_validator;
# atoi "b";
# if [[ "a" == "a" && "p" == "b" || "c" == "c"  ]]; then
# echo "true";
# fi;

# file_name_validator;

# printf '%c' 112;

# char=$(atoi "a");
# char="A";
# echo $(expr "97" + 0 )

# echo "A = " $(atoi "A") "Z = " $(atoi "Z") "a = " $(atoi "a") "z = " $(atoi "z") "var = " $char;

# if [[ $char -lt $(atoi "A") ||  $(atoi $char) -gt $(atoi "Z") && $(atoi $char) -lt $(atoi "a") || $(atoi $char) -gt $(atoi "z") ]]; then   
# echo "false";
# fi;

# char="a";

# if [[ $char < $(atoi "A") || $(atoi $char) > $(atoi "Z") || $(atoi $char) -gt $(atoi "Z") && $(atoi $char) -lt $(atoi "a") ]]; then
# echo "false";
# fi;

# if [[ $(atoi $char) -gt $(atoi "Z") && $(atoi $char) -lt $(atoi "a") || $char -lt $(atoi "A") || $char -gt $(atoi "z") ]]; then
# echo "false";
# fi;

# if [[ ascii_code < 65 || (ascii_code > 90 && ascii_code < 97) || ascii_code > 122 ]]; then
#     echo "Символ $character не является латинской буквой."
# else
#     echo "Символ $character является латинской буквой."
# fi;

# if [[ ! "$character" =~ ^[a-zA-Z]+$ ]]; then
#     echo "Символ $character yes"
# else
#     echo "Символ $character no"
# fi

string="aazziia";
n=14;
var="";
dot_position=3;
var1=${string:0:$dot_position};

#  if [[ ${#var1} < 7 ]]; then
# echo "true"
#     fi;

# if [[ ${#var1} < 7 ]]; then
#     echo "true"
# fi;

# echo $(${#string} / 2 != 0);

# ${#dir_letters};

var="aaa.aa";

# if [[ $var =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
#     echo "nice";
# fi;

dir_letters="asv.rav";
#  if [[ ! $dir_letters =~ ^[A-Za-z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
#         echo "ERROR: file name [$dir_letters] doesn't match pattern *{1,7}.*{1,3}*";
#         exit -1;
#     fi;

file_name_composer;