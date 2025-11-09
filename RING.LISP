(DEFINE-FILE-INFO PACKAGE "INTERLISP" READTABLE "INTERLISP" BASE 10)

(FILECREATED " 8-Nov-2025 21:54:13" {DSK}<home>ryan>il>RING.LISP;31 10082  

      :CHANGES-TO (FNS CLICK.FN PICK.RING.BY.ANGLE)
                  (VARS RINGCOMS)

      :PREVIOUS-DATE " 8-Nov-2025 20:52:04" {DSK}<home>ryan>il>RING.LISP;30)


(PRETTYCOMPRINT RINGCOMS)

(RPAQQ RINGCOMS ((FNS BALL.CORRECT.P CHOOSE CLICK.FN COMPUTE.ANGLE CREATE.BALL DRAW.BALL DRAW.RINGS 
                      FORM.3.RINGS GAME.WON.P HUNGARIAN.RINGS LIST.TO.ARRAY LOAD.RING.GRAPHICS 
                      MAKE.CIRCLES NGON.RADIUS PICK.RING.BY.ANGLE PLAY.RING SHIFT.BALL.COLORS 
                      SHUFFLE.RINGS)
                 (RECORDS BALL GAME.STATE)))
(DEFINEQ

(BALL.CORRECT.P
  [LAMBDA (BALL)
    "DOCSTRING TESTINGS"
    (EQP (FETCH COLOR OF BALL)
         (FETCH CORRECT.COLOR OF B])

(CHOOSE
  [LAMBDA (LIST)
    (CAR (NTH LIST (RAND 1 (LENGTH LIST])

(CLICK.FN
  [LAMBDA (W)
    (GETMOUSESTATE)
    (LET* ((BTNS (DECODEBUTTONS))
           (LEFTP (MEMBER 'LEFT BTNS))
           (RIGHTP (MEMBER 'RIGHT BTNS))
           (MIDDLEP (MEMBER 'MIDDLE BTNS))
           (MOUSE.X (LASTMOUSEX W))
           (MOUSE.Y (LASTMOUSEY W))
           (CEN.X (TIMES (WINDOWPROP W 'WIDTH)
                         1/2))
           (CEN.Y (TIMES (WINDOWPROP W 'HEIGHT)
                         1/2))
           (ANGLE (COMPUTE.ANGLE CEN.X CEN.Y MOUSE.X MOUSE.Y))
           (ROT.DIR (if LEFTP
                        then -1
                      elseif RIGHTP
                        then 1
                      else 0)))
          (if MIDDLEP
              then (DOWINDOWCOM W))
          (if (OR LEFTP RIGHTP)
              then (with GAME.STATE (CAR (WINDOWPROP W 'GAME.STATE))
                         (PROMPTPRINT (COMPUTE.ANGLE CEN.X CEN.Y MOUSE.X MOUSE.Y))
                         (SHIFT.BALL.COLORS (PICK.RING.BY.ANGLE CIRCS.LIST ANGLE)
                                ROT.DIR)
                         (DRAW.RINGS CIRCS.LIST BUFFER.STREAM)
                         (BITBLT WIN.BITMAP 0 0 W])

(COMPUTE.ANGLE
  [LAMBDA (X Y X2 Y2)
    (LET* ((DX (- X2 X))
           (DY (- Y2 Y))
           (ANGLE (ARCTAN2 DY DX)))
          (if (MINUSP ANGLE)
              then (SETQ ANGLE (+ ANGLE 360.0)))
          ANGLE])

(CREATE.BALL
  [LAMBDA (X Y COLOR CORRECT.COLOR)
    (create BALL
           X _ X
           Y _ Y
           COLOR _ (OR COLOR 0)
           CORRECT.COLOR _ (OR CORRECT.COLOR COLOR])

(DRAW.BALL
  [LAMBDA (BALL IMAGE-ARRAY STREAM)
    (with BALL BALL (LET [(SHADE (CASE COLOR
                                     ((0) GRAYSHADE2)
                                     ((1) GRAYSHADE)
                                     ((2) GRAYSHADE3)
                                     ((4) GRAYSHADE4)))
                          (SHADEBASE (CASE COLOR
                                         ((0) GRAYSHADE)
                                         ((1) GRAYSHADE3)
                                         ((2) BLACKSHADE)
                                         ((4) BLACKSHADE))]
                         (FILLCIRCLE X Y 16 SHADEBASE STREAM)
                         (FILLCIRCLE (- X 3)
                                (+ Y 3)
                                11 SHADE STREAM)
                         (DRAWCIRCLE X Y 16 NIL NIL STREAM)
                         (FILLCIRCLE (- X 6)
                                (+ Y 6)
                                4 WHITESHADE STREAM])

(DRAW.RINGS
  [LAMBDA (BALL.LISTS BUFFER.STREAM)
    (for BL in BALL.LISTS do (for I in BL do (with BALL I NIL (DRAW.BALL I NIL BUFFER.STREAM])

(FORM.3.RINGS
  [LAMBDA (CX CY)
    (LET* ((N 18.0)
           (LS 32.0)
           (A.X (+ CX 68.3382))
           (A.Y CY)
           (B.X (- CX 34.1691))
           (B.Y (- CY 59.182602))
           (C.X (- CX 34.1691))
           (C.Y (+ CY 59.182602))
           (STEP.ANGLE (/ 360.0 N))
           (RADIUS (NGON.RADIUS N LS))
           (CIRC.LIST.A (MAKE.CIRCLES A.X A.Y N LS 0.0 0))
           (CIRC.LIST.B (MAKE.CIRCLES B.X B.Y N LS 0.0 1))
           (CIRC.LIST.C (MAKE.CIRCLES C.X C.Y N LS 0.0 2)))
          (RPLACA (NTH CIRC.LIST.A 9)
                 (CAR (NTH CIRC.LIST.B 5)))
          (RPLACA (NTH CIRC.LIST.A 6)
                 (CAR (NTH CIRC.LIST.C 2)))
          (RPLACA (NTH CIRC.LIST.B 18)
                 (CAR (NTH CIRC.LIST.A 14)))
          (RPLACA (NTH CIRC.LIST.B 3)
                 (CAR (NTH CIRC.LIST.C 17)))
          (RPLACA (NTH CIRC.LIST.C 15)
                 (CAR (NTH CIRC.LIST.A 11)))
          (RPLACA (NTH CIRC.LIST.C 12)
                 (CAR (NTH CIRC.LIST.B 8)))
          (LIST CIRC.LIST.A CIRC.LIST.B CIRC.LIST.C])

(GAME.WON.P
  [LAMBDA (BALL.LIST)
    (EVERY BALL.LIST 'BALL.CORRECT.P])

(HUNGARIAN.RINGS
  [LAMBDA NIL
    (LET* ((W (DECODE.WINDOW.ARG NIL 480.0 480.0 
                     "HUNGARIAN RINGS (Mouse btns rotate. Middle click for menu..)"))
           (SOLVE.WINDOW (DECODE.WINDOW.ARG NIL 480.0 480.0 "SOLUTION PICTURE (EXACT POSITIONS)"))
           [WIN.BITMAP (BITMAPCREATE (WINDOWPROP W 'WIDTH)
                              (WINDOWPROP W 'HEIGHT]
           (BUFFER.STREAM (DSPCREATE WIN.BITMAP))
           (CX (TIMES (WINDOWPROP W 'WIDTH)
                      1/2))
           (CY (TIMES (WINDOWPROP W 'HEIGHT)
                      1/2))
           (CIRCS.LIST (FORM.3.RINGS CX CY))
           (GAME.STATE (create GAME.STATE
                              CIRCS.LIST _ CIRCS.LIST
                              BUFFER.STREAM _ BUFFER.STREAM
                              WIN.BITMAP _ WIN.BITMAP)))

          (* ;; " Now we add the GAME.STATE which is very important!")

          (WINDOWADDPROP W 'GAME.STATE GAME.STATE)

          (* ;; "Bring up the solved card and write the solved puzzle before shuffling")

          (DRAW.RINGS CIRCS.LIST BUFFER.STREAM)
          (BITBLT WIN.BITMAP 0 0 SOLVE.WINDOW)
          (SHUFFLE.RINGS CIRCS.LIST)

          (* ;; " Blitting once is faster than writing directly to window")

          (DRAW.RINGS CIRCS.LIST BUFFER.STREAM)
          (BITBLT WIN.BITMAP 0 0 W)

          (* ;; "We have to override BOTH because RIGHTBUTTONFN acts differently if not defined")

          (WINDOWPROP W 'BUTTONEVENTFN 'CLICK.FN)
          (WINDOWPROP W 'RIGHTBUTTONFN 'CLICK.FN)
          W])

(LIST.TO.ARRAY
  [LAMBDA (LIST ORIG)
    (LET* ((START (if (ZEROP ORIG)
                      then 0
                    else 1))
           (A (ARRAY (LENGTH LIST)
                     'POINTER NIL START)))
          (for X in LIST as I from START do (PRINT I)
                                            (SETA A I X))
          A])

(LOAD.RING.GRAPHICS
  [LAMBDA (FNAME)
    (PRINT "NOT IMPLEMENTED YET."])

(MAKE.CIRCLES
  [LAMBDA (CX CY N CIRCLES.DIAMETER START.DEGREES BALL.COLOR)
    (LET* ((START.DEGREES (OR START.DEGREES 0))
           (STEP.ANGLE (/ 360.0 N))
           (RADIUS (NGON.RADIUS N CIRCLES.DIAMETER)))
          (for I from 0 to (- N 1) collect (CREATE.BALL (+ CX (TIMES (COS (+ (TIMES I STEP.ANGLE)
                                                                             START.DEGREES))
                                                                     RADIUS))
                                                  (+ CY (TIMES (SIN (+ (TIMES I STEP.ANGLE)
                                                                       START.DEGREES))
                                                               RADIUS))
                                                  BALL.COLOR])

(NGON.RADIUS
  [LAMBDA (NUMSIDES SIDELENGTH)
    (/ SIDELENGTH (TIMES 2 (SIN (/ 180.0 NUMSIDES])

(PICK.RING.BY.ANGLE
  [LAMBDA (CIRCS.LIST ANGLE)
    (COND
       ((AND (> ANGLE 60)
             (<= ANGLE 180))
        (CAR (NTH CIRCS.LIST 3)))
       ((AND (> ANGLE 180)
             (<= ANGLE 300))
        (CAR (NTH CIRCS.LIST 2)))
       (T (CAR (NTH CIRCS.LIST 1])

(PLAY.RING
  [LAMBDA NIL
    (LET* ((W 800)
           (H 600)
           (WIN (DECODE.WINDOW.ARG NIL W H "HUNGARIAN RINGS")))
          (WINDOWADDPROP WIN 'LEVEL.LAYOUT)
          (WINDOWADDPROP WIN 'BALLS NIL)
          (WINDOWADDPROP WIN 'BUTTONS NIL)
          (WINDOWADDPROP WIN 'RINGS NIL)
          WIN])

(SHIFT.BALL.COLORS
  [LAMBDA (BALL.LIST DIRECTION NUM.TIMES)                    (* ; "DIRECTION MAYBE 1  (CLOCKWISE) OR -1 (COUNTER-CLOCKWISE) THE BALLS NEVER CHANGE POSITION IN THE LIST BUT THEIR COLORS DO")
    (LET [(NUM.TIMES (OR NUM.TIMES 1))
          (BALL.COLORS (for B in BALL.LIST collect (fetch COLOR of B]
         (FRPTQ NUM.TIMES [if (= DIRECTION -1)
                              then (SETQ BALL.COLORS (CONS (CAR (LAST BALL.COLORS))
                                                           (CL:BUTLAST BALL.COLORS)))
                            elseif (= DIRECTION 1)
                              then (SETQ BALL.COLORS (APPEND (CDR BALL.COLORS)
                                                            (LIST (CAR BALL.COLORS]
                (for C in BALL.COLORS as B in BALL.LIST do (replace COLOR of B with C])

(SHUFFLE.RINGS
  [LAMBDA (RING.LISTS)

    (* ;; "This algorithm is ham-fisted. Better shuffling is left as an exercise to the reader")

    (LET* [[LARGEST.COUNT (APPLY 'MAX (MAPCAR RING.LISTS 'LENGTH]
           (NUM.TURNS (TIMES LARGEST.COUNT (LENGTH RING.LISTS]
          (for I from 1 to (TIMES 2 NUM.TURNS) do (SHIFT.BALL.COLORS (CHOOSE RING.LISTS)
                                                         (- 1 (TIMES 2 (RAND 0 1)))
                                                         (RAND 1 2])
)
(DECLARE%: EVAL@COMPILE

(RECORD BALL (X Y COLOR CORRECT.COLOR))

(RECORD GAME.STATE (CIRCS.LIST BUFFER.STREAM WIN.BITMAP))
)
(DECLARE%: DONTCOPY
  (FILEMAP (NIL (727 9925 (BALL.CORRECT.P 737 . 882) (CHOOSE 884 . 954) (CLICK.FN 956 . 2153) (
COMPUTE.ANGLE 2155 . 2385) (CREATE.BALL 2387 . 2579) (DRAW.BALL 2581 . 3574) (DRAW.RINGS 3576 . 3755) 
(FORM.3.RINGS 3757 . 4822) (GAME.WON.P 4824 . 4900) (HUNGARIAN.RINGS 4902 . 6495) (LIST.TO.ARRAY 6497
 . 6866) (LOAD.RING.GRAPHICS 6868 . 6945) (MAKE.CIRCLES 6947 . 7771) (NGON.RADIUS 7773 . 7873) (
PICK.RING.BY.ANGLE 7875 . 8151) (PLAY.RING 8153 . 8468) (SHIFT.BALL.COLORS 8470 . 9382) (SHUFFLE.RINGS
 9384 . 9923)))))
STOP
