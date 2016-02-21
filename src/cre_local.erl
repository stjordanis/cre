%% -*- erlang -*-
%
% Cuneiform: A Functional Language for Large Scale Scientific Data Analysis
%
% Copyright 2016 Jörgen Brandt, Marc Bux, and Ulf Leser
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%    http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

-module( cre_local ).
-author( "Jorgen Brandt <brandjoe@hu-berlin.de>" ).

-behavior( cre ).
-export( [init/0, stage/3] ).

-define( BASEDIR, "/tmp/cf" ).
-define( WORKDIR, "work" ).

init() ->
  _Output = os:cmd( string:join( ["rm", "-rf", ?BASEDIR], " " ) ),
  ok.


stage( Lam={lam, _LamLine, LamName, _Sign, {forbody, Lang, Script}}, Fa, R ) ->

  Prefix = integer_to_list( R ),
  Dir = string:join( [?BASEDIR, ?WORKDIR, Prefix], "/" ),
  LangStr = atom_to_list( Lang ),
  _ScriptFilename = string:join( [string:join( [LamName, Prefix], "_" ), LangStr], "." ),

  % make sure working directory exists
  filelib:ensure_dir( [Dir, "/"] ),

  % create option list for effi
  OptList = [{dir, Dir}, {prefix, Prefix}|cre:get_optlist( Lam, Fa )],

  % start effi
  effi:check_run( OptList, Script ).