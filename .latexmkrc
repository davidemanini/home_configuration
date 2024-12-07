#! /usr/bin/perl

$pdf_mode = 1;
$pdf_previewer = 'xdg-open';

$preview_continuous_mode = 1;
$sleep_time = 0.1;

$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode';
@generated_exts = (@generated_exts, 'synctex.gz');


$failure_cmd   = "start notify-send \"LaTeXmk error\" \"File %D\" -t 2000";
$compiling_cmd   = "start notify-send \"Compiling\" \"File %D\" -t 2000";
