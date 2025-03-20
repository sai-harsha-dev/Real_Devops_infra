#!/bin/bash

function exec_status(){

    $1 &> /dev/null &

    while kill -0 $! 2> /dev/null
    do
        echo -e "$2"
        echo -e "\r"
        sleep 1
    done

    if [ $? == 0 ]
    then
        echo -e "Succesfully executed $1"
        return 0;
    else
        echo -e "Failed to execute $1"
        return 1;
    fi 

}