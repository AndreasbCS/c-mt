# C-MT: Emotional Reasoning
This repository presents a logic-based framework for modeling dynamics of human mental states, particularly in the setting of emotions. Psychological principles for emotion states and emotion transitions are captured in a transition system implemented using Answer Set Programming (ASP). 

Different emotion theories are formalized: the Appraisal theory of Emotion (AE), Hedonic Emotion Regulation (HER), and Utilitarian Emotion Regulation (UER), capturing links between human emotions and their underlying causes. 

* Emotion states: By following the psychological theory of AE, where emotions are defined based on need_consistency, goal_consistency, accountability, and control_potential, an emotion state-space is defined, through which a set of 16 basic human emotions can be explained. 
* Emotion transitions: By following the theories of HER and UER, different constraints for emotional-change are defined. HER focuses on augmenting positive emotions while diminishing negative ones. Conversely, UER seeks to promote particular emotions, including potentially negative ones, that enhance specific attributes, such as motivation or control, serving a utilitarian purpose in the long run. Consequently, HER and UER adopt contrasting principles for effecting emotional change. By examining the trajectories produced through the application of either HER or UER within the state-space of AE, we can compare and evaluate their respective behaviors.

## Emotional Reasoning Program, DATASET (init-goal paris) and Test Results
This repository contains: 
* An ASP program with [Hedonic Emotion Regulation (HER) based constraints](https://github.com/AndreasbCS/c-mt/blob/main/CAE-HER.lp)
* An ASP program with [Utilitarian Emotion Regulation (UER) based constraints](https://github.com/AndreasbCS/c-mt/blob/main/CAE-UER.lp). 
* A synthetic [dataset](https://github.com/AndreasbCS/c-mt/blob/main/CAE-init-goal-dataset.lp) with 256 input-goal pairs. 
* Two series of test results based on 512 runs of the program. The test results consist of [256 runs](https://github.com/AndreasbCS/c-mt/blob/main/CAE16%20Hedonic%20Test%20Results.pdf) using HER-based integrity constraints, and [256 runs](https://github.com/AndreasbCS/c-mt/blob/main/CAE16%20Utilitarian%20Test%20Results.pdf) using UER-based integrity constraints.

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

The program generates a plan (sequence of actions) that follows principles for Hedonic Emotion Regulation or Utilitarian Emotion Regulation, based on an initial emotion state leading to a goal emotion state.

### Results of test cases: Hedonic versus Utilitarian emotion regulation constraints.

The plans are generated from the logic program with either hedonic or utilitarian integrity constraints. 
Encoded in Answer Set Programming (ASP).

* Initial states and goal states represent the 16 emotions defined by Appraisal Theory of Emotion.
* Plans span from each initial state to each goal state following Utilitarian Emotion Regulation.
* An emotion state is a configuration of four classes and their values.
* A plan is a sequence of action from an initial state to a goal state.

The initial state and the goal state is configured using the following classes and values:

```
Classes:                    need_consistency, goal_consistency, accountability, control_potential

Explaination of values in number format:    For the classes:

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



### Authors

* Andreas Brännström {andreasb@cs.umu.se} [Homepage](https://people.cs.umu.se/andreasb/)
* Juan Carlos Nieves {jcnieves@cs.umu.se} [Homepage](https://www.umu.se/en/staff/juan-carlos-nieves/)

Department of Computing Science  
Umeå university  
SE-901 87, Umeå, Sweden  
