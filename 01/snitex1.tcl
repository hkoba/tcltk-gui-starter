#!/bin/sh
# -*- mode: tcl; coding: utf-8 -*-
# the next line restarts using wish \
    exec wish -encoding utf-8 "$0" ${1+"$@"}

package require Tcl 8.5; # or later.
package require snit
package require BWidget; # Very old, but stable and still useful.

snit::widget myex1 {

    # snit では、オブジェクトに所属させたい変数は全て、
    # widget 宣言内の variable コマンドか component コマンドで
    # 列挙する必要がある

    # オブジェクトに所属する変数の名前を付けるとき、
    # my で始まる名前に統一しておいた方が、後々の混乱を減らせる。
    # 
    # variable myText
    # 中に入れるのが widget などの snit object の場合は、
    # component コマンドを使っておくと、分かりやすいし、少し便利になる
    component myText

    # radio ボタンを作るようなケースでは, snit の option にしておくと便利
    option -qtype sa
    option -savsize 1

    constructor args {

	# この widget (myex1) 全体のパスが $win に入るので、
	# 中に入れたい部品には全て $win. 以下のパス名を付ける必要がある。
	#   widget の名前を考えるのが面倒な時は, .w[incr i] などで名前を
	#   連番で振っても構わない。
	pack [set lf [labelframe $win.w[incr i] -text "ツールバー"]] \
	    -fill x -expand no

	# callback command は [list $self メソッド名  (引数...)] 形式で登録する
	pack [button $lf.w[incr i] -text "Run" -command [list $self Run]] \
	    -side left

	pack [set w [labelframe $lf.w[incr i] -text sa/ma]] -side left
	foreach t {sa ma} {
	    # widget に渡す変数は [myvar インスタンス変数名] で登録する
	    pack [radiobutton $w.w[incr i] \
		      -value $t -variable [myvar options(-qtype)]]
	}

	pack [set w [labelframe $lf.w[incr i] -text "save size"]] \
	    -side left
	foreach t {1 2} {
	    # puts myvar=[myvar options(-savsize)]
	    pack [radiobutton $w.w[incr i] \
		      -value $t -variable [myvar options(-savsize)]]
	}

	pack [set w [ScrolledWindow $win.sw]] -fill both -expand yes
	install myText using text $w.t
	$w setwidget $myText

	$self configurelist $args
    }

    method Run {} {
	puts "Hello! $options(-qtype) $options(-savsize) [$self curtext]"
    }

    method curtext {} {
	$myText get 1.0 end-1c
    }
}

if {[info level] == 0 && [info script] eq $::argv0} {
    pack [myex1 .win {*}$::argv]
}
