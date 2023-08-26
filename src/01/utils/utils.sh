#!/bin/bash

function mul_float() {
    echo "$1 * $2" | bc;
}

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
    echo $(stat -t "%d-%m-%Y %H:%M:%S" $1 | awk '{print $9, $10}' | tr -d \");
}

# $1 - нижняя граница $2 - верхняя
function randnum() {
    echo $(shuf -i $1-$2 -n 1);
}