%==============================================================================
% Author information
%==============================================================================
% EMOTION DECISION-GRAPH
% Heuristics in the action language: C-AE.
%
% Theoretical base:
% * Based on the Appraisal theory of Emotion (AE).
%
% * Author: Andreas Brännström
% * E-mail: andreasb@cs.umu.se
% * Umeå University
% * 2023-05-24
%
%==============================================================================
% Running the program
%==============================================================================
%
% C:\clingo>clingo CAE-UER.lp
%
%==============================================================================
% Logic Program: Emotion Decision Graph
%==============================================================================

% Knowledge base
%==============================================================================

% Possible values for need_consistency, goal_consistency, control_potential, accountability

value(1..7).
% 1: low			need|goal|control
% 2: undecided		need|goal|control
% 3: high			need|goal|control
% 4: undecided 		accountability
% 5: other 			accountability
% 6: self 			accountability
% 7: environment 	accountability

% Variables
%==============================================================================
mind(need_consistency).
mind(goal_consistency).
mind(accountability).
mind(control_potential).

% Observation
%==============================================================================
init_on(need_consistency, 1).
init_on(goal_consistency, 3).
init_on(accountability, 5).
init_on(control_potential, 1).

% Goal
%==============================================================================
goal_on(need_consistency, 3).
goal_on(goal_consistency, 1).
goal_on(accountability, 6).
goal_on(control_potential, 3).

plan_length(6).

% Display
#show influence/3.


% Generate
%==============================================================================
{ influence(MS,V,T) : mind(MS), value(V) } = 1 :- plan_length(M), T = 1..M.

% Define
%==============================================================================
influence(MS,T) :- influence(MS,_,T).
on(MS,V,0) :- init_on(MS,V).
on(MS,V,T) :- influence(MS,V,T).
on(MS,V,T+1) :- on(MS,V,T), not influence(MS,T+1), not plan_length(T).

% C-AE: Integrity constraints
%==============================================================================

:- goal_on(MS,V), not on(MS,V,M), plan_length(M).
:- { on(MS,V,T) } != 1, mind(MS), plan_length(M), T = 1..M.

% Integrity constraints for well-formed emotion fluent
:- influence(need_consistency, 4, T+1).
:- influence(need_consistency, 5, T+1).
:- influence(need_consistency, 6, T+1).
:- influence(need_consistency, 7, T+1).
:- influence(goal_consistency, 4, T+1).
:- influence(goal_consistency, 5, T+1).
:- influence(goal_consistency, 6, T+1).
:- influence(goal_consistency, 7, T+1).
:- influence(control_potential, 4, T+1).
:- influence(control_potential, 5, T+1).
:- influence(control_potential, 6, T+1).
:- influence(control_potential, 7, T+1).
:- influence(accountability, 1, T+1).
:- influence(accountability, 2, T+1).
:- influence(accountability, 3, T+1).

% UTILITARIAN EMOTION REGULATION
% Influence emotions for utilitarian gain.

% Need consistency can only be influenced to high.
:- influence(need_consistency,1,T+1).
:- influence(need_consistency,2,T+1).

% The goal consistency can only be influenced to low or undecided, and the need consistency must be high.
:- influence(goal_consistency,1,T+1), on(need_consistency, 1, T).
:- influence(goal_consistency,1,T+1), on(need_consistency, 2, T).
:- influence(goal_consistency,2,T+1), on(need_consistency, 1, T).
:- influence(goal_consistency,2,T+1), on(need_consistency, 2, T).
:- influence(goal_consistency,3,T+1), on(need_consistency, 1, T).
:- influence(goal_consistency,3,T+1), on(need_consistency, 2, T).
:- influence(goal_consistency,3,T+1), on(need_consistency, 3, T).


% Accountability can only be influenced to self or environment. If environment, then the control must be high.
:- influence(accountability,4,T+1).
:- influence(accountability,5,T+1).
:- influence(accountability,7,T+1), on(control_potential, 1, T).
:- influence(accountability,7,T+1), on(control_potential, 2, T).

% Control potential can only be influenced to High.
:- influence(control_potential, 1, T+1).
:- influence(control_potential, 2, T+1).

% --- end ---

% Dataset with 256 init-goal pairs:

%Anger-Anger: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3). 
%Hope-Anger: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3).
%Joy-Anger: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3). 
%Relief-Anger: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3). 
%Dislike-Anger: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3).
%Frustration-Anger: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3).
%Liking-Anger: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3). 
%Regret-Anger: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3). 
%Disgust-Anger: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3).
%Fear-Anger: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3).
%Pride-Anger: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3).
%Shame-Anger: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3).
%Sadness-Anger: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3).
%Distress-Anger: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3).
%Surprise-Anger: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3). 
%Guilt-Anger: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 3). 
 
%Anger-Hope: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1). 
%Hope-Hope: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1).
%Joy-Hope: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1). 
%Relief-Hope: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1). 
%Dislike-Hope: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1).
%Frustration-Hope: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1).
%Liking-Hope: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1). 
%Regret-Hope: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1). 
%Disgust-Hope: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1).
%Fear-Hope: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1).
%Pride-Hope: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1).
%Shame-Hope: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1).
%Sadness-Hope: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1).
%Distress-Hope: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1).
%Surprise-Hope: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1). 
%Guilt-Hope: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 1). 

%Anger-Joy: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Hope-Joy: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Joy-Joy: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Relief-Joy: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Dislike-Joy: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Frustration-Joy: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Liking-Joy: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Regret-Joy: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Disgust-Joy: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Fear-Joy: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Pride-Joy: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Shame-Joy: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Sadness-Joy: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Distress-Joy: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Surprise-Joy: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Guilt-Joy: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
 
%Anger-Relief: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Hope-Relief: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2).
%Joy-Relief: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Relief-Relief: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Dislike-Relief: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2).
%Frustration-Relief: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2).
%Liking-Relief: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Regret-Relief: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Disgust-Relief: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2).
%Fear-Relief: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2).
%Pride-Relief: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2).
%Shame-Relief: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2).
%Sadness-Relief: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2).
%Distress-Relief: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2).
%Surprise-Relief: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 
%Guilt-Relief: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 7). goal_on(control_potential, 2). 

%Anger-Dislike: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1). 
%Hope-Dislike: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1).
%Joy-Dislike: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1).
%Relief-Dislike: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1). 
%Dislike-Dislike: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1).
%Frustration-Dislike: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1).
%Liking-Dislike: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1). 
%Regret-Dislike: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1). 
%Disgust-Dislike: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1).
%Fear-Dislike: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1).
%Pride-Dislike: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1).
%Shame-Dislike: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1).
%Sadness-Dislike: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1).
%Distress-Dislike: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1).
%Surprise-Dislike: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1). 
%Guilt-Dislike: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 5). goal_on(control_potential, 1). 

%Anger-Frustration: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Hope-Frustration: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Joy-Frustration: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Relief-Frustration: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3). 
%Dislike-Frustration: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Frustration-Frustration: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Liking-Frustration: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3). 
%Regret-Frustration: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3). 
%Disgust-Frustration: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Fear-Frustration: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Pride-Frustration: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Shame-Frustration: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Sadness-Frustration: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Distress-Frustration: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Surprise-Frustration: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3). 
%Guilt-Frustration: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3). 

%Anger-Liking: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2).
%Hope-Liking: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2).
%Joy-Liking: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2).
%Relief-Liking: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2). 
%Dislike-Liking: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2).
%Frustration-Liking: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2).
%Liking-Liking: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2). 
%Regret-Liking: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2). 
%Disgust-Liking: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2).
%Fear-Liking: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2).
%Pride-Liking: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2).
%Shame-Liking: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2).
%Sadness-Liking: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2).
%Distress-Liking: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2).
%Surprise-Liking: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2). 
%Guilt-Liking: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 5). goal_on(control_potential, 2).

%Anger-Regret: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1).
%Hope-Regret: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1).
%Joy-Regret: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1).
%Relief-Regret: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1).
%Dislike-Regret: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1).
%Frustration-Regret: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1).
%Liking-Regret: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1). 
%Regret-Regret: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1). 
%Disgust-Regret: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1).
%Fear-Regret: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1).
%Pride-Regret: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1).
%Shame-Regret: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1).
%Sadness-Regret: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1).
%Distress-Regret: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1).
%Surprise-Regret: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1). 
%Guilt-Regret: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 1).

%Anger-Disgust: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Hope-Disgust: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Joy-Disgust: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Relief-Disgust: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Dislike-Disgust: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Frustration-Disgust: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Liking-Disgust: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Regret-Disgust: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Disgust-Disgust: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Fear-Disgust: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Pride-Disgust: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Shame-Disgust: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Sadness-Disgust: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Distress-Disgust: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).
%Surprise-Disgust: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3). 
%Guilt-Disgust: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 3).

%Anger-Fear: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Hope-Fear: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Joy-Fear: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Relief-Fear: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Dislike-Fear: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Frustration-Fear: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Liking-Fear: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Regret-Fear: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Disgust-Fear: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Fear-Fear: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Pride-Fear: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Shame-Fear: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Sadness-Fear: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Distress-Fear: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Surprise-Fear: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Guilt-Fear: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).

%Anger-Pride: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Hope-Pride: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Joy-Pride: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Relief-Pride: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Dislike-Pride: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Frustration-Pride: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Liking-Pride: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Regret-Pride: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Disgust-Pride: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Fear-Pride: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Pride-Pride: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Shame-Pride: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Sadness-Pride: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Distress-Pride: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Surprise-Pride: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).
%Guilt-Pride: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 2).

%Anger-Shame: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Hope-Shame: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Joy-Shame: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Relief-Shame: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Dislike-Shame: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Frustration-Shame: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Liking-Shame: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Regret-Shame: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Disgust-Shame: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Fear-Shame: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Pride-Shame: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Shame-Shame: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Sadness-Shame: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Distress-Shame: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Surprise-Shame: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).
%Guilt-Shame: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 6). goal_on(control_potential, 3).

%Anger-Sadness: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Hope-Sadness: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Joy-Sadness: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Relief-Sadness: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Dislike-Sadness: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Frustration-Sadness: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Liking-Sadness: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Regret-Sadness: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Disgust-Sadness: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Fear-Sadness: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Pride-Sadness: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Shame-Sadness: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Sadness-Sadness: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Distress-Sadness: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Surprise-Sadness: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Guilt-Sadness: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).

%Anger-Distress: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Hope-Distress: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Joy-Distress: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Relief-Distress: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Dislike-Distress: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Frustration-Distress: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Liking-Distress: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Regret-Distress: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Disgust-Distress: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Fear-Distress: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Pride-Distress: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Shame-Distress: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Sadness-Distress: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Distress-Distress: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Surprise-Distress: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).
%Guilt-Distress: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 1). goal_on(goal_consistency, 1). goal_on(accountability, 7). goal_on(control_potential, 1).

%Anger-Surprise: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Hope-Surprise: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Joy-Surprise: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Relief-Surprise: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Dislike-Surprise: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Frustration-Surprise: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Liking-Surprise: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Regret-Surprise: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Disgust-Surprise: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Fear-Surprise: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Pride-Surprise: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Shame-Surprise: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Sadness-Surprise: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Distress-Surprise: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Surprise-Surprise: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).
%Guilt-Surprise: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 2). goal_on(goal_consistency, 2). goal_on(accountability, 7). goal_on(control_potential, 2).

%Anger-Guilt: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Hope-Guilt: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Joy-Guilt: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Relief-Guilt: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Dislike-Guilt: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 5). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Frustration-Guilt: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Liking-Guilt: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 5). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Regret-Guilt: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Disgust-Guilt: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Fear-Guilt: 
%init_on(need_consistency, 2). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Pride-Guilt: 
%init_on(need_consistency, 2). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Shame-Guilt: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Sadness-Guilt: 
%init_on(need_consistency, 3). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Distress-Guilt: 
%init_on(need_consistency, 1). init_on(goal_consistency, 1). init_on(accountability, 7). init_on(control_potential, 1). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Surprise-Guilt: 
%init_on(need_consistency, 2). init_on(goal_consistency, 2). init_on(accountability, 7). init_on(control_potential, 2). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).
%Guilt-Guilt: 
%init_on(need_consistency, 3). init_on(goal_consistency, 3). init_on(accountability, 6). init_on(control_potential, 3). goal_on(need_consistency, 3). goal_on(goal_consistency, 3). goal_on(accountability, 6). goal_on(control_potential, 3).



