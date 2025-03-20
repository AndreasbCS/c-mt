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

% Observation (Initial State)
%==============================================================================
init_on(need_consistency, high).
init_on(goal_consistency, high).
init_on(accountability, environment).
init_on(control_potential, undecided).

% Goal States
%==============================================================================
goal_on(need_consistency, high).
goal_on(goal_consistency, high).
goal_on(accountability, environment).
goal_on(control_potential, high).

% Define the time range
#const t_max = 6.
time(0..t_max). 

% Display relevant predicates
%#show occurs/2.
#show holds/2.

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

%==============================================================================
% Generate actions and fluents
%==============================================================================

fluent(F) :- fluent_h(F).
action(A) :- action_h(A).

fluent_h(MS, V) :- mental_fluent(MS, V). 
action_h(influence(MS, V)) :- mental_fluent(MS, V).

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

% Ensure that each mental state fluent has exactly one value at any time step
:- #count { V : holds(mental_fluent(MS, V), T) } != 1, psychological_class(MS), time(T).

% Ensure that all goal states are reached by the final time step
:- goal_on(MS, V), not holds(mental_fluent(MS, V), t_max).

%==============================================================================
% HEDONIC EMOTION REGULATION
%==============================================================================

:- holds(mental_fluent(need_consistency, high), T+1), holds(mental_fluent(goal_consistency, low), T), time(T).
:- holds(mental_fluent(need_consistency, high), T+1), holds(mental_fluent(goal_consistency, undecided), T), time(T).
:- holds(mental_fluent(need_consistency, undecided), T+1), holds(mental_fluent(goal_consistency, low), T), time(T).
:- holds(mental_fluent(need_consistency, undecided), T+1), holds(mental_fluent(goal_consistency, undecided), T), time(T).

:- holds(mental_fluent(goal_consistency, low), T+1), holds(mental_fluent(goal_consistency, V1), T), V1 != low, time(T).
:- holds(mental_fluent(goal_consistency, undecided), T+1), holds(mental_fluent(goal_consistency, V1), T), V1 != undecided, time(T).

%==============================================================================
% Integrity constraints for control potential variable
%==============================================================================

:- holds(mental_fluent(control_potential, high), T+1), holds(mental_fluent(goal_consistency, low), T), time(T).

:- holds(mental_fluent(control_potential, high), T+1), holds(mental_fluent(need_consistency, high), T), 
   holds(mental_fluent(goal_consistency, low), T), holds(mental_fluent(accountability, other), T), time(T).

:- holds(mental_fluent(control_potential, high), T+1), holds(mental_fluent(need_consistency, high), T), 
   holds(mental_fluent(goal_consistency, undecided), T), holds(mental_fluent(accountability, other), T), time(T).

:- holds(mental_fluent(control_potential, high), T+1), holds(mental_fluent(need_consistency, high), T), 
   holds(mental_fluent(goal_consistency, low), T), holds(mental_fluent(accountability, self), T), time(T).

:- holds(mental_fluent(control_potential, high), T+1), holds(mental_fluent(need_consistency, high), T), 
   holds(mental_fluent(goal_consistency, undecided), T), holds(mental_fluent(accountability, self), T), time(T).

:- holds(mental_fluent(control_potential, high), T+1), holds(mental_fluent(need_consistency, high), T), 
   holds(mental_fluent(goal_consistency, low), T), holds(mental_fluent(accountability, undecided), T), time(T).

:- holds(mental_fluent(control_potential, high), T+1), holds(mental_fluent(need_consistency, high), T), 
   holds(mental_fluent(goal_consistency, undecided), T), holds(mental_fluent(accountability, undecided), T), time(T).

% --- end ---

%==============================================================================
% Define C_TAID Components
%==============================================================================

% Fluent observations hold.
%:- not holds(F,T), fluent(F), time(T).

% Fluent or its negation holds
%holds(F,0) :- not holds(neg(F),0), fluent(F).
%holds(neg(F),0) :- not holds(F,0), fluent(F).

% Ensure fluents and their negations are contradictory
%:- holds(F, T), holds(neg(F), T), fluent(F), time(T).

% Inertial fluents retain their values unless overridden
%%holds(F, T+1) :- holds(F, T), not holds(neg(F, T+1)), not default(F), fluent(F), time(T).

% Set default values for non-inertial fluents
%holds(F, T) :- default(F), fluent(F), time(T), not holds(neg(F), T).

% Triggering rule: Actions occur when required fluents hold
%holds(occurs(A)) :- not holds(ab(occurs(A))), holds(F, T), fluent(F), action(A), time(T).

% Allowance rule: Actions are allowed when enabling conditions hold
%holds(allow(occurs(A))) :- not holds(ab(occurs(A))), holds(F, T), fluent(F), action(A), time(T).

% Ensure exogenous actions can always occur
%holds(allow(occurs(A))) :- action(A), time(T).

% Inhibition rule: Prevent actions under certain conditions
%holds(ab(occurs(A))) :- holds(F, T), action(A), fluent(F), time(T).

% No-concurrency constraint: Ensures only one action per timestep
%:- time(T), #count { A : holds(occurs(A)) } > 1.

% Observations and initial conditions
%holds(F, 0) :- init_on(F).

% Generate possible completions of the initial state
%{ holds(F, 0) ; holds(neg(F), 0) } :- fluent(F).

% An action occures if it is allowed and not inhibited.
%holds(occurs(a),T) :- holds(allow(occurs(a)),T),
%not holds(ab(occurs(a)),T), not holds(neg(occurs(a)),T),
%action(a), time(T), T < t_max.

% An action is negated if it does not occure.
%holds(neg(occurs(a)),T) :- not holds(occurs(a),T),
%action(a), time(T), T < t_max.

% Ensure goal achievement using goal_on()
%%achieved(T) :- goal_on(MA,V), holds(F, T), fluent(F), time(T).

