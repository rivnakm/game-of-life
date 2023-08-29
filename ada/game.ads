V "GNAT Lib v13"
A -O3
P SS ZX

RN
RV NO_DIRECT_BOOLEAN_OPERATORS
RV NO_EXCEPTIONS
RV NO_IO
RV NO_STANDARD_STORAGE_POOLS
RV NO_DEFAULT_INITIALIZATION
RV NO_DYNAMIC_SIZED_OBJECTS
RV NO_IMPLEMENTATION_PRAGMAS

U game%b		game.adb		84f588a6 NE OO PK IU
W ada%s			ada.ads			ada.ali
W ada.characters%s	a-charac.ads		a-charac.ali
W ada.characters.latin_1%s  a-chlat1.ads	a-chlat1.ali
W ada.integer_text_io%s	a-inteio.ads		a-inteio.ali
W ada.numerics%s	a-numeri.ads		a-numeri.ali
W ada.numerics.discrete_random%s
Z ada.strings.text_buffers%s  a-sttebu.adb	a-sttebu.ali
W ada.text_io%s		a-textio.adb		a-textio.ali
W system%s		system.ads		system.ali
Z system.random_numbers%s  s-rannum.adb		s-rannum.ali

U game%s		game.ads		982bc2c3 EE NE OO PK IU
Z ada.strings.text_buffers%s  a-sttebu.adb	a-sttebu.ali

D ada.ads		20230802070638 76789da1 ada%s
D a-assert.ads		20230802070638 ba465f5c ada.assertions%s
D a-charac.ads		20230802070638 2d3ec45b ada.characters%s
D a-chlat1.ads		20230802070638 e0d72e76 ada.characters.latin_1%s
D a-except.ads		20230802070638 2a7d8d70 ada.exceptions%s
D a-inteio.ads		20230802070638 f64b89a4 ada.integer_text_io%s
D a-ioexce.ads		20230802070638 40018c65 ada.io_exceptions%s
D a-numeri.ads		20230802070638 84bea7a3 ada.numerics%s
D a-nubinu.ads		20230802070638 93f1f3d1 ada.numerics.big_numbers%s
D a-nbnbig.ads		20230802070638 711e0174 ada.numerics.big_numbers.big_integers_ghost%s
D a-nudira.ads		20230802070638 5984dff3 ada.numerics.discrete_random%s
D a-nudira.adb		20230802070638 0bfd6ec4 ada.numerics.discrete_random%b
D a-stream.ads		20230802070638 119b8fb3 ada.streams%s
D a-string.ads		20230802070638 90ac6797 ada.strings%s
D a-sttebu.ads		20230802070638 f1ad67a2 ada.strings.text_buffers%s
D a-stuten.ads		20230802070638 c6ced0ae ada.strings.utf_encoding%s
D a-tags.ads		20230802070638 9eaa38c6 ada.tags%s
D a-textio.ads		20230802070638 5c2c6153 ada.text_io%s
D a-tiinio.ads		20230802070638 e58fa6fb ada.text_io.integer_io%s
D a-unccon.ads		20230802070638 0e9b276f ada.unchecked_conversion%s
D game.ads		20230821024042 982bc2c3 game%s
D game.adb		20230821024042 0fea5317 game%b
D interfac.ads		20230802070638 15f799c2 interfaces%s
D i-cstrea.ads		20230802070638 e53d8b8e interfaces.c_streams%s
D system.ads		20230802070638 426dafb8 system%s
D s-assert.ads		20230802070638 9c4520c7 system.assertions%s
D s-casuti.ads		20230802070638 cf13d755 system.case_util%s
D s-crtl.ads		20230802070638 8a0692f8 system.crtl%s
D s-exctab.ads		20230802070638 91bef6ef system.exception_table%s
D s-ficobl.ads		20230802070638 dc5161d4 system.file_control_block%s
D s-imageu.ads		20230802070638 631c6ed0 system.image_u%s
D s-imguns.ads		20230802070638 7867236f system.img_uns%s
D s-parame.ads		20230802070638 d494a4a6 system.parameters%s
D s-putima.ads		20230802070638 17291fe4 system.put_images%s
D s-rannum.ads		20230802070638 95815eca system.random_numbers%s
D s-rannum.adb		20230802070638 0f2dcb9a system.random_numbers%b
D s-ransee.ads		20230802070638 01a57b33 system.random_seed%s
D s-secsta.ads		20230802070638 578279f5 system.secondary_stack%s
D s-soflin.ads		20230802070638 df77073e system.soft_links%s
D s-stache.ads		20230802070638 0b81c1fe system.stack_checking%s
D s-stalib.ads		20230802070638 1c9580f6 system.standard_library%s
D s-stoele.ads		20230802070638 ab5468e4 system.storage_elements%s
D s-stoele.adb		20230802070638 8f5a9db6 system.storage_elements%b
D s-traent.ads		20230802070638 c81cbf8c system.traceback_entries%s
D s-unstyp.ads		20230802070638 fa2a7f59 system.unsigned_types%s
D s-valuns.ads		20230802070638 e8a1f424 system.val_uns%s
D s-valuti.ads		20230802070638 fcd603d8 system.val_util%s
D s-valueu.ads		20230802070638 18770347 system.value_u%s
D s-vauspe.ads		20230802070638 a67b2f28 system.value_u_spec%s
D s-wchcon.ads		20230802070638 d9032363 system.wch_con%s
D s-widuns.ads		20230802070638 866a5800 system.wid_uns%s
D s-widthu.ads		20230802070638 b32f15e2 system.width_u%s
G a e
G c Z s b [get_cell game 4 14 none]
G c Z s b [run_game game 5 15 none]
G c Z s b [next_generation game 6 15 none]
G c Z s b [draw_screen game 7 15 none]
G c Z s s [gridIP game 3 10 none]
X 1 ada.ads
16K9*Ada 20e8 22|1r6 1r23 2r6 2r31 3r6 4r6 10r36 14r9 22r17
X 3 a-charac.ads
16K13*Characters 18e19 22|4r10 22r21
X 4 a-chlat1.ads
16K24*Latin_1 294e27 22|4w21 22r32
51e4*ESC{character} 22|22r40
X 6 a-inteio.ads
18K13*Integer_Text_IO[19|46] 22|2w10 2r35 14m13
X 8 a-numeri.ads
16K13*Numerics 35e17 22|3r10 10r40
X 11 a-nudira.ads
44k22*Discrete_Random 81e33 22|3w19 10r49
50R9 Generator<35|65R9> 22|12r13[10]
52V13 Random{21|2E10} 22|17s25[10]
X 12 a-nudira.adb
53V16 Random[35|86]{21|2E10} 36|402b13[22|10]
65V16 Random[35|86]{21|2E10} 36|402b13[22|10]
X 18 a-textio.ads
58K13*Text_IO 787e16 22|1w10 1r27
88I12*Field{integer}
519U14*Put 22|22s13 22s65 82s21 84s21
566U14*Put_Line 22|87s13
X 19 a-tiinio.ads
48i4*Default_Width{18|88I12} 22|14m29[6|18]
83U14*Put 22|22s52[6|18]
X 21 game.ads
1K9*GAME 8l5 8e9 22|6b14 90l5 90t9
2E10*CELL 2e31 3r45 4r79 22|10r66 27r79 39r19
2n19*ALIVE{2E10} 22|53r108 59r30 67r36 81r43
2n26*DEAD{2E10} 22|32r20 61r36 63r36
3A10*GRID(2E10)<integer> 4r31 6r46 7r35 22|9r17 27r31 36r46 38r22 77r35
4V14*GET_CELL{2E10} 4>23 4>37 4>45 4>52 4>57 22|27b14 34l9 34t17 48s28 53s56
4a23 BOARD{3A10} 22|27b23 30r20
4i37 HEIGHT{integer} 22|27b37 29r45
4i45 WIDTH{integer} 22|27b45 29r62 30r32
4i52 ROW{integer} 22|27b52 29r13 29r39 30r26
4i57 COL{integer} 22|27b57 29r26 29r56 30r40
5U15*RUN_GAME 5>24 5>32 5>39 22|7b15 25l9 25t17
5i24 HEIGHT{integer} 22|7b24 8r36 21r32 22r56 23r36
5i32 WIDTH{integer} 22|7b32 8r45 21r40 23r44
5i39 GENERATIONS{integer} 22|7b39 20r23
6U15*NEXT_GENERATION 6=31 6>52 6>60 22|23s13 36b15 75l9 75t24
6a31 BOARD{3A10} 22|36b31 43r30 71m17
6i52 HEIGHT{integer} 22|36b52 37r36 46r23 48r49 53r77
6i60 WIDTH{integer} 22|36b60 37r45 47r27 48r57 53r85 71r27
7U15*DRAW_SCREEN 7>27 7>41 7>49 22|21s13 77b15 89l9 89t20
7a27 BOARD{3A10} 22|77b27 81r20
7i41 HEIGHT{integer} 22|77b41 79r23
7i49 WIDTH{integer} 22|77b49 80r27 81r30
X 22 game.adb
8i9 SIZE{integer} 9r25 16r23
9a9 BOARD{21|3A10} 17m13 21r25 23m29 23r29
10K17 RANDOM_CELL[11|44] 11r13
12r9 G{11|50R9[10]} 17r32
16i13 I{integer} 17r19
20i13 I{integer}
37i9 SIZE{integer} 38r30 42r23
38a9 BOARD_COPY{21|3A10} 43m13 48r37 53r65
39e9 CURRENT{21|2E10} 48m17 59r20 61m25 63m25 67m25 71r41
40i9 ADJACENT{integer} 49m17 54m29 54r41 60r24 62r27 66r24
42i13 I{integer} 43r24 43r36
46i13 I{integer} 48r64 53r92 71r23
47i17 J{integer} 48r67 53r99 71r35
51i21 N{integer} 53r34 53r96
52i25 M{integer} 53r44 53r103
79i13 I{integer} 81r26
80i17 J{integer} 81r38
X 23 interfac.ads
80M9*Unsigned_32
83M9*Unsigned_64
X 35 s-rannum.ads
77V13*Random{23|80M9} 36|224i21
78V13*Random{23|83M9} 36|224i21

