hanimecheck
===========
A crappy Haskell port of [taufix's crc checker](http://agafix.org/anime-crc32-checksum-in-linux-v20/), mainly written for me to get some experience using haskell.

Installation
------------
The build system is [tup](http://gittup.org/tup/) and we depend on `haskell-regex-posix` and `haskell-digest`, so you need to install those first somehow. Then:

    tup init
    tup upd

builds it straight away. Then put `hanimecheck` anywhere in your PATH.

Usage
-----

Usage is the same as the original program.

    ~/Videos/anime/guilty crown$ hanimecheck *
    B83741C2   [Tsuki-Hatsuyuki]_Guilty_Crown_-_02_[704x400][B83741C2].avi
    8CC3978E   [Tsuki-Hatsuyuki]_Guilty_Crown_-_03_[704x400][8CC3978E].avi
    1BE874F7   [Tsuki-Hatsuyuki]_Guilty_Crown_-_04_[704x400][1BE874F7].avi

Except with checksums colored green/red for matching/nonmatching, which I can't seem to represent in markdown. We don't bother to do any exception handling, so trying to checksum a directory or any unreadable path will throw an error and stop checking. But, we do safely ignore any filename that doesn't contain a 8-hexdigit checksum in `[SQUARE BRACKETS]`.
