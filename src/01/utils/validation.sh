function dir_name_validator() {
    if [[ ! $dir_letters =~ ^[A-Za-z]{1,7}$ ]]; then
        echo "ERROR: dir name [$dir_letters] is invalid";
        exit -1;
    fi;
}

function file_name_validator() {
    if [[ ! $file_letters =~ ^[A-Za-z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
        echo "ERROR: file name [$file_letters] is invalid";
        exit -1;
    fi;
}
function file_size_validator() {
    if [[ ! $file_size =~  ^(100|[1-9]{1}[0-9]{1}|[1-9]{1})(kb|Kb|KB)?$ ]]; then
        echo "ERROR: file size [$file_size] is invalid";
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


function arg_validator() {
    if [[ $arg_length -ne 6 ]]; then
        echo "ERROR: script requires 6 args"
        exit -1;
    fi
    dir_name_validator
    file_name_validator;
    file_size_validator;  
}


