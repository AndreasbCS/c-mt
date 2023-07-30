# c-mt
A framework for modeling dynamics of human mental states. Psychological principles for constraining mental-state transitions is implemented as a transition system using Answer Set Programming (ASP). 

## Emotional Reasoning Program and Test Results
This repository presents an ASP implementation of an Emotion Decision Graph (EDG), a synthetic dataset with 256 input-goal pairs, and two series of test results based on 512 runs of the program. This consists of 256 runs using Hedonic Emotion Regulation (HER) based integrity constraints, and 256 runs using Utilitarian Emotion Regulation (UER) based integrity constraints.

### Prerequisites

CLINGO: https://potassco.org/clingo/

CLINGO is an Answer Set Programming system to ground and solve logic programs.

### Running the program

For Hedonic Emotion Regulation: 
```
Command line: C:\clingo>clingo CAE-HER.lp
```
For Utilitarian Emotion Regulation: 
```
Command line: C:\clingo>clingo CAE-UER.lp
```

The program generates a plan (sequence of actions) that follows principles for HER or UER, based on an initial emotion state leading to a goal emotion state.

### Results of test cases: Hedonic versus Utilitarian emotion regulation constraints.

The plans are generated from the logic program with either hedonic or utilitarian integrity constraints. 
Encoded in Answer Set Programming (ASP).

* Initial states and goal states represent the 16 emotions defined by Appraisal Theory of Emotion.
* Plans span from each initial state to each goal state following Utilitarian Emotion Regulation.
* An emotion state is a configuration of four classes and their values.
* A plan is a sequence of action from an initial state to a goal state.

```
Classes:                    need_consistency, goal_consistency, accountability, control_potential

Values in number format:    For the classes:

1: low                      need_consistency | goal_consistency | control_potential
2: undecided                need_consistency | goal_consistency | control_potential
3: high                     need_consistency | goal_consistency | control_potential
4: undecided                accountability
5: other                    accountability
6: self                     accountability
7: environment              accountability

Initial state format:        init_on(Class, Value). for each class.
Goal state format:           goal_on(Class, Value). for each class.
Plan action format:          influence(Class,Value,Time) for each action.
```

