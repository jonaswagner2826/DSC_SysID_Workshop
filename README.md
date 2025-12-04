# CSSC - System Identification Workshop
### Event Details
- **Location:** ECSW 3.325 (Systems and Controls Lab)
- **Time:** Thursday 2025-12-04 @ 14:00-16:00
- **Organizers:** Juned Shaikh and Reillan Sawyer
- **Acknowledgments:** Jonas Wagner, Yi Tian, and Dr. Justin Koeln



## Introduction to System Identification
System identification is a critical methodology for building mathematical models of dynamic systems based on observed data. This workshop explores various system identification techniques used in practice to model complex systems. Participants will gain hands-on experience with frequency response-based identification tools and learn to apply them in practical scenarios using an active suspension experimental system. A brief introduction to nonlinear system identification techniques will also be given. Download the slides here to follow along during the workshop  [docs/SysIDWorkshopSlides.pdf](docs/SysIDWorkshopSlides.pdf).



### Physics-based Model
We will start by first comparing the physics-based model of the active suspension system to the experimental system, to see how accurately it models the experimental system. See the QUARC document [docs\Active Suspension - Laboratory Guide.pdf](docs/Active%20Suspension%20-%20Laboratory%20Guide.pdf) for more detailed derivation of the model.



### System Identification
Next we will be perturbing the experimental system with various kinds of input signals to collect the system response, which we will be then using for identifying the transfer function of the system. This will be where you will be using the MATLAB systemID tools and try to identify the right model for the system response that most accurately captures all system dynamics. We will then artificially corrupt out data with process noise, measurement noise, and signal delays, and observe how this effects our estimiate of the model. Few techniques to mtigate these issues will also be discussed.



### Discovering the Governing Equations using Data
A breif introduction to Nonlinear system identification will be given by using the sparse identification technique to recover by the governing equations for a simple Lorenz system completely from data.
