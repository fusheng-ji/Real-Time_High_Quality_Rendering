---
typora-root-url: ./
---

# Real-Time_High_Quality_Rendering
It's a notebook of Real-Time High Quality Rendering (GAMES 202) by Lingqi Yan 2021

![微信截图_20220212021425](/pic/微信截图_20220212021425.png)

Class website: https://sites.cs.ucsb.edu/~lingqi/teaching/games202.html

## Overview

### What is Real-Time High Quality Rendering about?

- Real-Time

  - Speed: more than 30 FPS (frames per second), even more for Virtual / Augmented Reality (VR / AR): 90 FPS
  - Interactivity: Each frame generated on the fly

- High Quality

  - Realism: advanced approaches to make rendering more realistic
  - Dependability: all-time correctness (exact or approximate), no tolerance to (uncontrollable) failures

- Rendering

  - ```mermaid
    graph LR
    1["3D scene (meshes, lights, etc)"]  --> 2[Calculating<br>light->eye]-->3[Image]
    ```

- Highest level: 4 different parts on real-time rendering
  - Shadows (and env)
  - Global Illum. (Scene/image space, precomputed)
  - Physically-based Shading
  - Real-time rag tracing

![2022-03-13_09-37](pic/2022-03-13_09-37.png)

### Course Topics

- Shadow and Environment Mapping

  ![2022-03-13_09-38](pic/2022-03-13_09-38.png)

- Interactive Global Illumination Techniques

  ![2022-03-13_09-38_1](pic/2022-03-13_09-38_1.png)

- Precomputed Radiance Transfer

  ![2022-03-13_09-39](pic/2022-03-13_09-39.png)

- Real-Time Ray Tracing

- Participating Media Rendering, Image Space Effects, etc.

  ![2022-03-13_09-39_1](pic/2022-03-13_09-39_1.png)

- Non-Photorealistic Rendering

  - But will not be in depth / per game

  ![2022-03-13_09-41](pic/2022-03-13_09-41.png)

- Antialiasing and supersampling

  ![2022-03-13_09-41_1](/pic/2022-03-13_09-41_1.png)

- Chatting about techs!

  ![2022-03-13_09-41_2](/pic/2022-03-13_09-41_2.png)

- Chatting about games!

  ![2022-03-13_09-42](/pic/2022-03-13_09-42.png)

### What's is GAMES202 not about?

- 3D modeling or game development using Unreal Engine

  ![2022-03-13_09-59](/pic/2022-03-13_09-59.png)

- Off-line rendering: Expensive (but more accurate) light transport techniques
  in movies / animations

  ![2022-03-13_09-59_1](/pic/2022-03-13_09-59_1.png)

- Neural Rendering

  ![2022-03-13_09-59_2](/pic/2022-03-13_09-59_2.png)

- Using OpenGL

- Scene / shader optimization

- Reverse engineering of shaders

- High performance computing e.g. CUDA programming

### How to study GAMES202?

- Understand the difference between science and technology
  - Science != technology
  - Science == knowledge
  - Technology == engineering skills that turn science into product
- Real-time rendering = fast & approximate off-line rendering + systematic engineering
- Fact: in real-time rendering technologies, the industry is way ahead of the academia
- Practice makes perfect

### Motivation

- Today, Computer Graphics is able to generate photorealistic images
  - Complex geometry, lighting, materials, shadows
  - Computer-generated movies/special effects (difficult or impossible to tell real from rendered...)

![2022-03-13_10-19](/pic/2022-03-13_10-19.png)

- But accurate algorithms (esp. ray tracing) are very slow
  - So they are called offline rendering methods
  - Remember how long it takes to render 1 frame in Zootopia?

![2022-03-13_10-23](/pic/2022-03-13_10-23.png)

- With proper approximations, we can generate plausible results but runs much faster

![2022-03-13_10-24](/pic/2022-03-13_10-24.png)

### Evolution of Real-Time Rendering

- Interactive 3D graphics pipeline as in OpenGL

  - Earliest SGI machines (Clark 82) to today
  - Most of focus on more geometry, texture mapping
  - Some tweaks for realism (shadow mapping, accum. buffer)

  ![2022-03-13_10-26](/pic/2022-03-13_10-26.png)

- 20 years ago

  - Interactive 3D geometry with simple texture mapping, fake shadows (OpenGL, DirectX)

    ![2022-03-13_10-27](/pic/2022-03-13_10-27.png)

- 20 -> 10 years ago

  - A giant leap since the emergence of programmable shaders (2000)

  - Complex environment lighting, real materials (velvet, satin, paints), soft shadows

    ![2022-03-13_10-27_1](/pic/2022-03-13_10-27_1.png)

- Today

  - Stunning graphics

    ![2022-03-13_10-30](/pic/2022-03-13_10-30.png)

  - Extended to Virtual Reality (VR) and even movies

    ![2022-03-13_10-30_1](/pic/2022-03-13_10-30_1.png)

### Technological and Algorithmic Milestones

- Programmable graphics hardware (shaders) (20 years ago)

  ![2022-03-13_10-31](/pic/2022-03-13_10-31.png)

- Precomputation-based methods (15 years ago)

  - Complex visual effects are (partially) pre-computed

  - Minimum rendering cost at run time

    ![2022-03-13_10-32](/pic/2022-03-13_10-32.png)

  - Application: Relighting

    - Fix geometry
    - Fix viewpoint
    - Dynamically change lighting

    ![2022-03-13_10-34](/pic/2022-03-13_10-34.png)

- Interactive Ray Tracing (8-10 years ago: CUDA + OptiX)

  - Hardware development allows ray tracing on GPUs at low sampling rates (~1 samples per pixel (SPP))

  - Followed by post processing to denoise

    ![2022-03-13_10-35](/pic/2022-03-13_10-35.png)

## Recap of CG Basics

### Basic GPU hardware pipeline

![2022-03-13_11-41](/pic/2022-03-13_11-41.png)

![2022-03-13_11-42](/pic/2022-03-13_11-42.png)

![2022-03-13_11-42_1](/pic/2022-03-13_11-42_1.png)

![2022-03-13_11-42_2](/pic/2022-03-13_11-42_2.png)

![2022-03-13_11-42_3](/pic/2022-03-13_11-42_3.png)

![2022-03-13_11-43](/pic/2022-03-13_11-43.png)

### OpenGL

- Is a set of APIs that call the GPU pipeline from CPU
  - Therefore, language does not matter!
  - Cross platform
  - Alternatives (DirectX, Vulkan, etc.)
- Cons
  - Fragmented: lots of different versions
  - C style, not easy to use
  - Cannot debug (?)
- Understanding
  - 1-to-1 mapping to our software rasterizer in GAMES101

#### How to use OpenGL? Important analogy: oil painting

##### A. Place objects/models

- Model specification
  - User specifies an object’s vertices, normals, texture coords and send them to GPU as a Vertex buffer object (VBO)
    - Very similar to .obj files
- Model transformation
  - Use OpenGL functions to obtain matrices
    - e.g., glTranslate, glMultMatrix, etc.
    - No need to write anything on your own

##### B. Set position of an easel

- View transformation

- Create / use a framebuffer

  - Set camera (the viewing transformation matrix) by simply calling, e.g., gluPerspective

    ![2022-03-13_11-50](/pic/2022-03-13_11-50.png)

##### C. Attach a canvas to the easel

- Analogy of oil painting:
  - E. you can also paint multiple pictures using the same easel
- One rendering pass in OpenGL
  - A framebuffer is specified to use
  - Specify one or more textures as output (shading, depth, etc.)
  - Render (fragment shader specifies the content on each texture)

##### D. Paint to the canvas

- i.e., how to perform shading
- This is when vertex / fragment shaders will be used
- For each vertex in parallel
  - OpenGL calls user-specified vertex shader: Transform vertex (ModelView, Projection), other ops
- For each primitive, OpenGL rasterizes
  - Generates a fragment for each pixel the fragment covers
- For each fragment in parallel
  - OpenGL calls user-specified fragment shader: Shading and lighting calculations
  - OpenGL handles z-buffer depth test unless overwritten
- This is the “Real” action that we care about the most: user-defined vertex, fragment shaders
  - Other operations are mostly encapsulated
  - Even in the form of GUI-s

##### E. (Attach other canvases to the easel and continue painting)

##### F. Multiple passes! (Use previous paintings for reference)

##### Summary: in each pass

- Specify objects, camera, MVP, etc.
- Specify framebuffer and input/output textures
- Specify vertex / fragment shaders
- (When you have everything specified on the GPU) Render!

### OpenGL Shading Language (GLSL)

#### Shading Languages

- Vertex / Fragment shading described by small program
- Written in language similar to C but with restrictions
- Long history. Cook’s paper on Shade Trees, Renderman for offline rendering
  - In ancient times: assembly on GPUs!
  - Stanford Real-Time Shading Language, work at SGI
  - Still long ago: Cg from NVIDIA
  - HLSL in DirectX (vertex + pixel)
  - GLSL in OpenGL (vertex + fragment)

#### Shader Setup

- Initializing (shader itself discussed later)
  - Create shader (Vertex and Fragment)
  - Compile shader
  - Attach shader to program
  - Link program
  - Use program
- Shader source is just sequence of strings
- Similar steps to compile a normal program

![2022-03-13_12-02](/pic/2022-03-13_12-02.png)

![2022-03-13_12-03](/pic/2022-03-13_12-03.png)

![2022-03-13_12-03_1](/pic/2022-03-13_12-03_1.png)

[Vertex Shader](Assignments/Assignment0/src/shaders/phongShader/vertex.glsl)

![2022-03-13_12-03_2](/pic/2022-03-13_12-03_2.png)

![2022-03-13_12-04](/pic/2022-03-13_12-04.png)

[Fragment Shader](Assignments/Assignment0/src/shaders/phongShader/fragment.glsl)

#### Debugging Shaders

![2022-03-13_13-59](/pic/2022-03-13_13-59.png)

![2022-03-13_13-59_1](/pic/2022-03-13_13-59_1.png)

### The Rendering Equation

![2022-03-13_14-00](/pic/2022-03-13_14-00.png)

![2022-03-13_14-01](/pic/2022-03-13_14-01.png)

#### Environment Lighting

![2022-03-13_14-02_1](/pic/2022-03-13_14-02_1.png)

![2022-03-13_14-02_2](/pic/2022-03-13_14-02_2.png)

![2022-03-13_14-02_3](/pic/2022-03-13_14-02_3.png)

## Real-Time Shadows

### Recap: shadow mapping

- A 2-Pass Algorithm
  - Pass 1 - The light pass generates the SM
  - Pass 2 - The camera pass uses the SM (recall last lecture)
- An image-space algorithm
  - Pro: no knowledge of scene’s geometry is required
  - Con: causing self occlusion and aliasing issues
- Well known shadow rendering technique
  - Basic shadowing technique even for early off-line renderings, e.g., Toy Story

#### Overview

![2022-03-13_14-16](/pic/2022-03-13_14-16.png)

![2022-03-13_14-18](/pic/2022-03-13_14-18.png)

![2022-03-13_14-19](/pic/2022-03-13_14-19.png)

![2022-03-13_14-19_1](/pic/2022-03-13_14-19_1.png)

#### Results

![2022-03-13_14-20](/pic/2022-03-13_14-20.png)

![2022-03-13_14-20_1](/pic/2022-03-13_14-20_1.png)

#### Visualization

![2022-03-13_14-20_2](/pic/2022-03-13_14-20_2.png)

![2022-03-13_14-20_3](/pic/2022-03-13_14-20_3.png)

![2022-03-13_14-20_4](/pic/2022-03-13_14-20_4.png)

![2022-03-13_14-21](/pic/2022-03-13_14-21.png)

#### Issues and solutions

##### Self occlusion

![2022-03-13_14-22](/pic/2022-03-13_14-22.png)

###### How to fix? (RTR does not trust in COMPLEXITY)

![2022-03-13_14-22_1](/pic/2022-03-13_14-22_1.png)

![2022-03-13_14-22_2](/pic/2022-03-13_14-22_2.png)

##### Aliasing

![2022-03-13_14-32](/pic/2022-03-13_14-32.png)

### The math behind shadow mapping

#### Inequalities in Calculus

![2022-03-13_14-34](/pic/2022-03-13_14-34.png)

#### Approximation in RTR

![2022-03-13_14-34_1](/pic/2022-03-13_14-34_1.png)

![2022-03-13_14-35](/pic/2022-03-13_14-35.png)

![2022-03-13_14-36](/pic/2022-03-13_14-36.png)

### Percentage closer soft shadows (PCSS)

![2022-03-13_14-37](/pic/2022-03-13_14-37.png)

#### Percentage Closer Filtering (PCF)

![2022-03-13_14-37_1](/pic/2022-03-13_14-37_1.png)

![2022-03-13_14-37_2](/pic/2022-03-13_14-37_2.png)

![2022-03-13_14-38](/pic/2022-03-13_14-38.png)

![2022-03-13_14-46](/pic/2022-03-13_14-46.png)

![2022-03-13_14-38_1](/pic/2022-03-13_14-38_1.png)

![2022-03-13_14-40](/pic/2022-03-13_14-40.png)

![2022-03-13_14-40_1](/pic/2022-03-13_14-40_1.png)

![2022-03-13_14-40_2](/pic/2022-03-13_14-40_2.png)

![2022-03-13_14-41](/pic/2022-03-13_14-41.png)

![2022-03-13_14-41_1](/pic/2022-03-13_14-41_1.png)

### Basic filtering techniques

![2022-03-13_15-12](/pic/2022-03-13_15-12.png)

![2022-03-13_15-15](/pic/2022-03-13_15-15.png)

$$V(x)\ne \sum_{y\in \mathcal{N}(x)}w(x,y)V(y)$$

![2022-03-13_15-19](/pic/2022-03-13_15-19.png)

### Variance soft shadow mapping (VSSM)

![2022-03-13_15-21](/pic/2022-03-13_15-21.png)

![2022-03-13_15-21_1](/pic/2022-03-13_15-21_1.png)

![2022-03-13_15-21_2](/pic/2022-03-13_15-21_2.png)

![2022-03-13_15-21_3](/pic/2022-03-13_15-21_3.png)

![2022-03-13_15-21_4](/pic/2022-03-13_15-21_4.png)

![2022-03-13_15-21_5](/pic/2022-03-13_15-21_5.png)

![2022-03-13_15-21_6](/pic/2022-03-13_15-21_6.png)

![2022-03-13_15-22](/pic/2022-03-13_15-22.png)

![2022-03-13_15-22_1](/pic/2022-03-13_15-22_1.png)

### MIPMAP and Summed-Area Tables (SAT) Variance Shadow Maps

![2022-03-13_15-25](/pic/2022-03-13_15-25.png)

![2022-03-13_15-25_1](/pic/2022-03-13_15-25_1.png)

![2022-03-13_15-25_2](/pic/2022-03-13_15-25_2.png)

![2022-03-13_15-26](/pic/2022-03-13_15-26.png)

### Moment (矩) shadow mapping

![2022-03-13_16-18](/pic/2022-03-13_16-18.png)

![2022-03-13_16-19](/pic/2022-03-13_16-19.png)

![2022-03-13_16-19_1](/pic/2022-03-13_16-19_1.png)

![2022-03-13_16-20](/pic/2022-03-13_16-20.png)

![2022-03-13_16-20_1](/pic/2022-03-13_16-20_1.png)

![2022-03-13_16-20_2](/pic/2022-03-13_16-20_2.png)

![2022-03-13_16-20_3](/pic/2022-03-13_16-20_3.png)

![2022-03-13_16-20_4](/pic/2022-03-13_16-20_4.png)

## Real-Time Environment Mapping

### Finishing up on shadows

![2022-03-13_16-46](/pic/2022-03-13_16-46.png)

#### Distance field soft shadows

![2022-03-13_16-46_1](/pic/2022-03-13_16-46_1.png)

![2022-03-13_16-46_2](/pic/2022-03-13_16-46_2.png)

![2022-03-13_16-46_3](/pic/2022-03-13_16-46_3.png)

![2022-03-13_16-46_4](/pic/2022-03-13_16-46_4.png)

![2022-03-13_16-47](/pic/2022-03-13_16-47.png)

![2022-03-13_16-47_1](/pic/2022-03-13_16-47_1.png)

![2022-03-13_16-47_2](/pic/2022-03-13_16-47_2.png)

![2022-03-13_16-47_3](/pic/2022-03-13_16-47_3.png)

![2022-03-13_16-47_4](/pic/2022-03-13_16-47_4.png)

![2022-03-13_16-50](/pic/2022-03-13_16-50.png)

![2022-03-13_16-50_1](/pic/2022-03-13_16-50_1.png)

### Shading from environment lighting

![2022-03-13_17-21](/pic/2022-03-13_17-21.png)

![2022-03-13_17-21_1](/pic/2022-03-13_17-21_1.png)

![2022-03-13_17-21_2](/pic/2022-03-13_17-21_2.png)

![2022-03-13_17-21_3](/pic/2022-03-13_17-21_3.png)

![2022-03-13_17-21_4](/pic/2022-03-13_17-21_4.png)

#### The split sum approximation

![2022-03-13_17-21_5](/pic/2022-03-13_17-21_5.png)

![2022-03-13_17-22](/pic/2022-03-13_17-22.png)

![2022-03-13_17-22_1](/pic/2022-03-13_17-22_1.png)

![2022-03-13_17-22_2](/pic/2022-03-13_17-22_2.png)

![2022-03-13_17-22_3](/pic/2022-03-13_17-22_3.png)

![2022-03-13_17-22_4](/pic/2022-03-13_17-22_4.png)

![2022-03-13_17-22_5](/pic/2022-03-13_17-22_5.png)

![2022-03-13_17-22_6](/pic/2022-03-13_17-22_6.png)

![2022-03-13_17-22_7](/pic/2022-03-13_17-22_7.png)

![2022-03-13_17-23](/pic/2022-03-13_17-23.png)

### Shadow from environment lighting















