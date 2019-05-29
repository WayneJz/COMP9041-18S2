# COMP9041-18S2
COMP9041 Software Construction 2018S2

**ALL CODES SHOULD BE APPROPRIATELY REFERENCED, COPYING MAY RESULT IN PLAGIARISM**

Lecturer: Andrew Taylor

## Main content

1. **Shell**: Unix process, basic shell commands (cut, sort, sed, tr ...) and more in regex. Shell syntax (3 types of quotes, condition, loop, test...)

2. **Perl**: Perl syntax, special symbols and special variables, functions (subroutines) definition and calls, strings, arrays and hash arrays. Perl regex and file handling. Perl Modules and CPAN.

3. **Git**: Version control and git commands, merge conflict and branches.

4. **Webserver**: Perl TCP/IP socket programming, simple HTTP server. Perl multiprocessing and webCGI.

5. **JavaScript**: Node.js environment, Node modules. JavaScript syntax and ES6 syntax. Frontend DOM, query, promise and async functions, error/exception handling.

## Assignments

1. [Legit](./Assignment01/legit.pl) - Build a Git system by using Perl, having such functions implemented:

    - git init
    - git add
    - git commit [-a] [-m]
    - git log
    - git show
    - git rm [--force] [--cached]
    - git status
    - git branch [-d]
    - git checkout
    - git merge [-m]

    **To run the code, simply type `./legit.pl` for instructions.**

2. [InstaCram](./Assignment02/Instacram/frontend/index.html) - Build frontend for a photo sharing website in pure Node.js, having such functions implemented:

    - User log in, sign out and register by using tokens
    - User post a photo
    - User like a photo
    - User leave comments of a photo
    - User delete or update a post of photo
    - User's home page
    - User search for another user
    - User follow/unfollow another user
    - Infinite Scrolls and live update

    **To run the codes, please follow such steps:**
    
    1. Open a terminal type `cd Assignment02/Instacram/backend` and `pip3 install -r requirements.txt`
    2. `python3 run.py`
    3. Open another terminal type `cd Assignment02/Instacram/frontend` and `npm install`
    4. `npm start`

## Credits

All lecture/tutorial slides and materials come from the lecturer. Assignment 2 backend comes from Alex Hinds and Zain Afzal. Please ask them before referencing. I will take no responsibility for misuse.
