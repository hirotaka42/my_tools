@echo off
setlocal enabledelayedexpansion
rem 実行ファイルのディレクトリをカレントディレクトリに指定
cd /d %~dp0
rem ====================
rem Windows-BatchFiles
rem Ver-0.0.1
rem Release-2022-0525
rem ====================



rem mp4ファイルの読み込み,サブルーチンへ
for %%F in (*.mp4) do call :sub "%%F"
rem 終わったら終了
goto :EOF

:sub
rem ====================
rem サブルーチン
rem ====================
rem 環境変数設定
set "FilePath=%~dpn1.mp4"
set "FileName=%~n1"
set "pwd=%~dp0"
rem 一時的にmp4を吐き出すフォルダのパス
set "tmp=%pwd%\tmp"
rem ログフォルダのパス
set "log=%pwd%\log"
rem エンコード終了後の各保存先
set "encoded=%pwd%\encoded"
set "success=%pwd%\success"
set "failed=%pwd%\failed"
rem ループ処理用変数
set cnt=0
rem ディレクトリ作成
echo "tmp" >> dirlist.txt
echo "log" >> dirlist.txt
echo "encoded" >> dirlist.txt
echo "success" >> dirlist.txt
echo "failed" >> dirlist.txt
rem dirlist.txtに存在するフォルダ名が無ければ作成
for /f %%i in (dirlist.txt) do If not exist %%i mkdir %%i

:encode
rem ====================
rem エンコード ルーチン
rem ====================
rem 録画の開始終了でビジーなので負荷を減らすためにちょっと待つ
timeout /t 10 /nobreak
ffmpeg.exe -hide_banner -i "%FilePath%" -movflags +faststart -pix_fmt yuv420p -vf scale=1280:-1 -c:v libx264 -c:a aac "%tmp%\%FileName%_encoded.mp4"

rem 終了コードが1且つループカウントが25以下までの間、エンコードを試みる
if "%errorlevel%" equ "1" (
    if "%cnt%" leq "25" (
        set /a cnt+=1
        goto :encode
    ) else (
        goto :err
    )
)

move "%tmp%\%FileName%_encoded.mp4" "%encoded%"
move "%FilePath%" "%success%"
rem 終了
goto :EOF

:err
rem ====================
rem エラー ルーチン
rem ====================
rem ffmpegによるエラーのみ対応、シンタックスエラーやコマンドプロンプトの不具合はここに到達しないのでログを参照されたし
rem 異常終了
exit

