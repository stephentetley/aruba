/* 
    checks.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/  

:- use_module(library(pcre)).

:- object(checks).

    :- public(name_is_survey/1).
    name_is_survey(Name) :- 
        pcre::re_match("^1\\.survey\\Z"/i, Name), 
        !.

    :- public(name_is_site_work/1).
    name_is_site_work(Name) :- 
        pcre::re_match("2\\.site_work\\Z"/i, Name), 
        !.
    
    :- public(has_survey_folder/1).
    has_survey_folder(FileObj) :- 
        file_store_traversals::any_transform(has_survey_folder_aux, FileObj, false, Ans), 
        Ans = true,
        !.

    :- public(has_survey_folder_aux/3).
    has_survey_folder_aux(folder_object(Name, _, _, _), _, Acc) :- 
        name_is_survey(Name),
        Acc = true.

    %% fall through case
    has_survey_folder_aux(_, Acc, Acc).

    :- public(has_site_work_folder/1).
    has_site_work_folder(FileObj) :- 
        file_store_traversals::any_transform(has_site_work_folder_aux, FileObj, false, Ans), 
        Ans = true,
        !.

    :- public(has_site_work_folder_aux/3).
    has_site_work_folder_aux(folder_object(Name, _, _, _), _, Acc) :- 
        name_is_site_work(Name),
        Acc = true.

    %% fall through case
    has_site_work_folder_aux(_, Acc, Acc).

    :- public(get_kid_folder/3).
    get_kid_folder(Store, Name, Ans) :- 
        file_store_traversals::one_transform([Folder, _, Ans] >> (Folder = folder_object(Name,_ ,_, _), Ans = Folder, !), Store, '', Ans).

/*     :- public(check_site_work/2).
    check_site_work(Store, Ans) :- 
        file_store_traversals::all_transform("CSO_SPS") */




:- end_object.


