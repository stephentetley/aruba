% dummy.pl



% See SWI Prolog Manual Section 4.36 for direct file system 
% access predicates (not "file stores" / listings).
% e.g.
demo01 :- 
    exists_file("factbase/directories.pl").

demo02 :- 
    exists_file("factbase/DOES_NOT_EXIST.pl").

% Note 
demo03(Ext) :- 
    file_name_extension(_,Ext,"dir1/dir2/lib.dll").

demo04(File) :- 
    file_base_name("dir1/dir2/output.txt", File).

demo05(Directory) :- 
    file_directory_name("dir1/dir2/output.txt", Directory).
