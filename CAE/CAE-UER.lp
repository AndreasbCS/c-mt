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
% C:\clingo>clingo CAE.lp
%
%==============================================================================
% Logic Program: Emotion Decision Graph
%==============================================================================

% Knowledge base
%==============================================================================

% Possible values for need_consistency, goal_consistency, control_potential, accountability

psychological_value(low).
psychological_value(undecided).
psychological_value(high).
psychological_value(other).
psychological_value(self).
psychological_value(environment).

% Psychological classes representing mental states
psychological_class(need_consistency).
psychological_class(goal_consistency).
psychological_class(accountability).
psychological_class(control_potential).

% Define valid psychological values per class
wellformed_emotion_fluent(need_consistency, low).
wellformed_emotion_fluent(need_consistency, undecided).
wellformed_emotion_fluent(need_consistency, high).

wellformed_emotion_fluent(goal_consistency, low).
wellformed_emotion_fluent(goal_consistency, undecided).
wellformed_emotion_fluent(goal_consistency, high).

wellformed_emotion_fluent(accountability, undecided).
wellformed_emotion_fluent(accountability, other).
wellformed_emotion_fluent(accountability, self).
wellformed_emotion_fluent(accountability, environment).

wellformed_emotion_fluent(control_potential, low).
wellformed_emotion_fluent(control_potential, undecided).
wellformed_emotion_fluent(control_potential, high).

% Define mental fluents
mental_fluent(MS, V) :- wellformed_emotion_fluent(MS, V).

% Observation
%==============================================================================
init_on(need_consistency, low).
init_on(goal_consistency, high).
init_on(accountability, other).
init_on(control_potential, low).

% Goal
%==============================================================================
goal_on(need_consistency, high).
goal_on(goal_consistency, low).
goal_on(accountability, self).
goal_on(control_potential, high).

% Define the time range
#const t_max = 6.
time(0..t_max).

% Display relevant predicates
%#show occurs/2.
#show holds/2.

%==============================================================================
% Generate influence actions
%==============================================================================

% Define action instances as a wrapper for influence actions
action(influence(MS, V)) :- mental_fluent(MS, V).

% Generate influence actions as general actions
{ holds(occurs(A), T): action(A) } = 1 :- time(T), T > 0.

% Define holds/2
%==============================================================================

% Initial fluents
holds(mental_fluent(MS, V), 0) :- init_on(MS, V).

% If an influence action occurs at T, it changes the mental fluent at T+1
holds(mental_fluent(MS, V), T+1) :- holds(occurs(influence(MS, V)), T), time(T).

% Integrity Constraints
%==============================================================================

% Persistence: If no new influence occurs, the previous psychological_value persists
holds(mental_fluent(MS, V), T+1) :- holds(mental_fluent(MS, V), T), 
    not holds(occurs(influence(MS, _)), T), time(T).

% Ensure that each mental state has exactly one value at any time step
:- #count { V : holds(mental_fluent(MS, V), T) } != 1, psychological_class(MS), time(T).

% Ensure that all goal states are reached by the final time step
:- goal_on(MS, V), not holds(mental_fluent(MS, V), t_max).

%==============================================================================
% UTILITARIAN EMOTION REGULATION
% Influence emotions for utilitarian gain.
%==============================================================================

% Need consistency can only be influenced to high.
:- holds(mental_fluent(need_consistency, low), T+1), holds(mental_fluent(need_consistency, V1), T), V1 != low, time(T).
:- holds(mental_fluent(need_consistency, undecided), T+1), holds(mental_fluent(need_consistency, V1), T), V1 != undecided, time(T).

% The goal consistency can only be influenced to low or undecided, and the need consistency must be high.
:- holds(mental_fluent(goal_consistency, low), T+1), holds(mental_fluent(need_consistency, low), T), time(T).
:- holds(mental_fluent(goal_consistency, low), T+1), holds(mental_fluent(need_consistency, undecided), T), time(T).
:- holds(mental_fluent(goal_consistency, undecided), T+1), holds(mental_fluent(need_consistency, low), T), time(T).
:- holds(mental_fluent(goal_consistency, undecided), T+1), holds(mental_fluent(need_consistency, undecided), T), time(T).
:- holds(mental_fluent(goal_consistency, high), T+1), holds(mental_fluent(need_consistency, undecided), T), time(T).
:- holds(mental_fluent(goal_consistency, high), T+1), holds(mental_fluent(need_consistency, high), T), time(T).

% Accountability can only be influenced to self or environment. If environment, then the control must be high.
:- holds(mental_fluent(accountability, undecided), T+1), holds(mental_fluent(accountability, V1), T), V1 != undecided, time(T).
:- holds(mental_fluent(accountability, other), T+1), holds(mental_fluent(accountability, V1), T), V1 != other, time(T).
:- holds(mental_fluent(accountability, environment), T+1), holds(mental_fluent(control_potential, low), T), time(T).
:- holds(mental_fluent(accountability, environment), T+1), holds(mental_fluent(control_potential, undecided), T), time(T).

% Control potential can only be influenced to High.
:- holds(mental_fluent(control_potential, low), T+1), holds(mental_fluent(control_potential, V1), T), V1 != low, time(T).
:- holds(mental_fluent(control_potential, undecided), T+1), holds(mental_fluent(control_potential, V1), T), V1 != undecided, time(T).

% --- end ---
