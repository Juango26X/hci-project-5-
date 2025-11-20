# Data Sonification — Miniproject 5

Members
- Juan David Vasquez Pomar
- Santiago Guevara Idarraga

Project description
This project implements a data sonifier and visualizer using Processing and Pure Data. A public dataset is read and visualized in Processing; data attributes are mapped consistently to sound parameters in Pure Data so that visual and auditory representations express the same information. The visualization and sonification update dynamically as data is processed, and interactive adjustments to the visuals modify the sound in real time.

Dataset
- Title: "Pokemon"
- Source: Zenodo - https://zenodo.org/records/4661775

Design justification
- Processing was chosen for real-time visualization and rapid prototyping of interactive graphics.
- Pure Data was selected for flexible, low-latency sound synthesis and easy mapping of control messages from Processing.
- OSC (Open Sound Control) is used as the communication protocol for its simplicity and compatibility with both tools.
- Mapping strategy: numeric attributes (e.g., HP, Attack, Speed) map to pitch, amplitude, and temporal density; categorical attributes (e.g., type) map to timbre or synthesis presets. This combination preserves interpretability across visual and auditory channels and supports consistent user learning.


Final video: https://youtu.be/WbuWXy4uIIc
