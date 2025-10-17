# Football Manager Project


## Brief Description

This project is a football manager game inspired by PES 2017 and Top Eleven. It is meant to feature the tactics used to make a football manager game. This article will feature Artificial Intelligence techniques such as Behaviour Trees and state machines. It will also feature data structures and algorithms, including SQL basics. All these were implemented in the project’s current stage.

## Class Diagram

![Football Manager Class Diagram ](https://user-images.githubusercontent.com/53413092/189932003-d277cfec-d8dd-4fdf-8d73-eaae94975af2.png)

## Behaviour Tree
The behaviour tree is a custom AI behaviour designed to control the movement of players around the pitch

### Behaviour Tree Diagram
![Football Manager](https://github.com/user-attachments/assets/490c0247-1944-4735-8a36-ee4f5de434d4)

### Behaviour Tree Implementation
![FM_clone - bT](https://user-images.githubusercontent.com/53413092/185654892-f1060bd6-4dc5-44bd-938f-37da3f4d1508.png)

## High-level Architecture of a Football Intelligence System (or “team brain”)
### Three abstraction levels:

🧠 High-level (Conceptual / Architectural) – what the team brain and player brain represent and how they interact.

⚙️ Mid-level (Algorithmic / System design) – how to model their decision-making, adaptability, and compatibility.

🔬 Low-level (Implementation / Data-driven) – how to represent and update these in code and data structures (later).

## 🧠 HIGH-LEVEL OVERVIEW
1. Core Idea

Simulation represents intelligence through stats and interactions.
Each player has a Player Brain, and each team has a Team Brain.
These brains cooperate, conflict, and evolve through matches, training, and chemistry-building — much like neural learning.

2. Key Concept: “Neural Harmony”

Each player’s synergy index and understanding level form a “compatibility vector” with the team brain.
The closer this vector is to the team’s strategic vector, the smoother the play and the better the team performance.

### Player Brain
#### 🧠 1. Concept — What the Player Brain Represents

Each player has an internal neural network that:

Takes stimuli (match context, team instructions, ball state, pressure, stamina, etc.)

Activates neural pathways representing different strategies (pass, dribble, hold, press, shoot, reposition)

Outputs a decision vector — which action to take, and how confidently.

Adjusts synaptic weights (learning) after each event — depending on success, failure, or team feedback.

In short:

The Player Brain converts environment + team signals → decision + internal state update.

#### 🧩 2. Neural Architecture Overview
2.1 Input Layer (Perception)

Inputs represent the world as the player “feels” it.
Example vector (normalize to 0–1):

Input	Description
ball_distance	Distance to ball
goal_distance	Distance to opponent goal
nearest_enemy	Distance to nearest opponent
teammate_support	Average proximity of nearby teammates
stamina_level	1.0 = fresh, 0.0 = exhausted
pressure_level	Intensity of opponent press
team_alignment	Cosine similarity with team brain
form	Recent performance metric (momentum/confidence)
role_bias	Weight from tactical role (e.g. AMF, CB, etc.)

→ This becomes your input vector x (≈ 8–12 dimensions).

##### 2.2 Hidden Layer (Interpretation)

We simulate mental state neurons.
Each neuron corresponds to a mental bias:

Neuron	Meaning
RiskNeuron	tolerance for risky passes/shots
visionNeuron	awareness of team spacing
pressureNeuron	reaction under press
fatigueNeuron	resistance to exhaustion
adaptNeuron	ability to adapt to new tactics
egoNeuron	tendency to act individually

Each has an activation:

a_i = σ( Σ_j (w_ij * x_j) + b_i )


where σ = sigmoid or tanh activation.

Hidden neurons form the personality pattern of the player.

##### 2.3 Output Layer (Decision)

Outputs represent action tendencies:

Output	Meaning
shoot_prob	
pass_prob	
dribble_prob	
hold_prob	
press_prob	
retreat_prob	

The vector of outputs is normalized (softmax) so sum = 1.

You can then choose the action:

Deterministically: pick the max value

Probabilistically: sample based on output weights (makes behaviors less robotic)

## SQLITE

![FM_clone - sqlite](https://user-images.githubusercontent.com/53413092/185654907-b0ade895-76b8-4dcb-bb3a-1d5716a3bc65.png)

## Implementation

![FM_clone 1](https://user-images.githubusercontent.com/53413092/185654922-0fcbe708-369c-4d9d-8a11-b3a5ad2315dc.png)

![FM_clone 2](https://user-images.githubusercontent.com/53413092/185654927-42254970-b5a2-458d-8544-09159da6dc43.png)

![FM_clone 3](https://user-images.githubusercontent.com/53413092/185654931-768cdde2-fe9a-4311-b6b5-1f57d050bbed.png)

## Process

To see my thought process, look through this article on medium -> https://rotimia.medium.com/my-process-on-making-a-football-manager-clone-93e05903a843

## Youtube Video

https://youtu.be/QHi0OK6mLyc



