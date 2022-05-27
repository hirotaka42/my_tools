#!/bin/bash

# 実行ファイルのディレクトリをカレントディレクトリに移動
cd `dirname $0` 
# ====================
# mac-BatchFiles
# Ver-0.0.1
# Release-2022-0526
# ====================

function encode() {
    # wait sec
    wait 3
    echo -e "処理を開始します。"
    echo "$1"

    # ffmpeg -hide_banner -i "$1" \
    # -movflags+faststart \
    # -pix_fmt yuv420p \
    # -vf scale=1280:-1 \
    # -c:v h264_videotoolbox \
    # -c:a aac "sample.mp4"
}

function wait() {
    # Args:$1 中断したい時間
    chars="/-\|"
    for ((f=0; f<$1; f++));do echo -en "$(($1-f))秒待っています" "\r";for (( i=0; i<${#chars}; i++ )); do sleep 0.25; echo -en "${chars:$i:1}" "\r";done;done
}

function check_dir(){
    # ディレクトリ確認、存在しなければ作成
    DIR_NAMES="success failed tmp encoded"
    # インデックスに @ を指定して、全ての要素を for 文の値リストに指定
    # ディレクトリが存在しなければ作成
    for dir in ${DIR_NAMES[@]};do if [ ! -d $dir ]; then mkdir $dir;fi;done

}

function check_mp4(){
    #.mp4が存在しないならプログラム終了
    if [ ! -e *.mp4 ]; then echo "エンコードファイルが存在しません。"; exit 0;fi
    #.mp4が存在する場合、出力先ディレクトリを作成
    check_dir
    # .mp4を読み込みエンコードする
    ls | grep ".mp4" | while read line;do echo $line;encode $line;done
}

function main(){
    check_mp4
}

main

