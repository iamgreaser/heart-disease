Heart Disease
a TINS 2017 entry
Copyright (C) Ben "GreaseMonkey" Russell, 2017.
Check LICENCE.txt if you are unfamiliar with the terms of the MIT licence.

You will need Chicken Scheme to run this.
You will also need the allegro egg.
You may need to patch enums.scm in said egg to remove a particular enum which you will probably encounter when you try to compile it, unless someone has fixed that already.

Then, run this by typing in:

csi start.scm

To exit, just type

(exit)

into the REPL.

Have fun!

Controls:

WASD       = move
mouse      = aim
left click = shoot
P          = pause
R          = restart

If you modify this game, you can use one of these REPL commands to update it while it's running:

Load loadall.scm:
(!!)

Load deinit, init, loadall:
(__)

