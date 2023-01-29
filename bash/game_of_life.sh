#!/usr/bin/env bash
function next_gen() {
    cells_copy=("${cells[@]}")

    local i
    local j
    for (( i = 0; i< $height; i++ )) {
        for (( j = 0; j< $width; j++ )) {
            local index
            local cell
            let index=$i*$width+$j
            let cell=cells_copy[$index]
            local adjacent=0

            for (( n = -1; n <= 1; n++ )) {
                for (( m = -1; m <= 1; m++ )) {
                    if [[ $n -eq 0 && $m -eq 0 ]]; then
                        continue
                    fi

                    local row
                    local col
                    let row=$i+$n
                    let col=$j+$m
                    let index=$row*$width+$col
                    if [[ $row -ge 0 && $col -ge 0 && $row -lt $height && $col -lt $width && cells_copy[$index] -eq 1 ]]; then
                        let adjacent++
                    fi

                }
            }

            if [[ $cell -eq 1 ]]; then
                if [[ $adjacent -lt 2 ]]; then
                    cell=0
                fi
                if [[ $adjacent -gt 3 ]]; then
                    cell=0
                fi
            else
                if [[ $adjacent -eq 3 ]]; then
                    cell=1
                fi
            fi
            
            let index=$i*$width+$j
            cells[$index]="${cell}"
        }
    }
}

function draw_screen() {
    local i
    local j
    for (( i = 0; i< $height; i++ )) {
        for (( j = 0; j< $width; j++ )) {
            local index
            let index=$i*$width+$j
            if [ ${cells[$index]} -eq 1 ]; then
                echo -n "██"
            else
                echo -n "  "
            fi
        }
        echo ""
    }
}

generations=500
height=50
width=100
cells=()
cells_copy=()

for (( i = 0; i < (($height*$width)); i++ )) {
    let rand=$RANDOM%2
    cells+=($rand)
}

for (( i = 0; i < generations; i++ )) {
    draw_screen
    echo -en "\033[${height}A"
    next_gen
}
