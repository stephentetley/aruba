% files_dummy.pl

user:file_search_path(aruba, '../src/aruba').

:- use_module(aruba(file_store/operations)).

% See SWI Prolog Manual Section 4.36 for direct file system 
% access predicates (not "file stores" / listings).
% e.g.
demo01 :- 
    exists_file("../src/factbase/directories.pl").

demo02 :- 
    exists_file("../src/factbase/DOES_NOT_EXIST.pl").

% Note 
demo03(Ext) :- 
    file_name_extension(_,Ext,"dir1/dir2/lib.dll").

demo04(File) :- 
    file_base_name("dir1/dir2/output.txt", File).

demo05(Directory) :- 
    file_directory_name("dir1/dir2/output.txt", Directory).

% Need PCRE cheat sheet...




test01(Ans) :- 
    get_extension("dir1/dir2/goal.xml", Ans).


get_basename(FileName, Ans) :- 
    re_matchsub("(?<base>.*)(?:\\.)(?<ext>[^\\.]+)$", FileName, Dict, []),
    get_dict('base',Dict,Ans).



