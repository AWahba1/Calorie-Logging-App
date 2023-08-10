<br>
<br>
<h1 style="margin-bottom:0; margin-top:50;" align="center">Calorie-Logging-App</h1>

<p  align="center">A mobile app designed to automate the calorie logging process by enabling users to log the calories in their meals automatically from an image captured by their mobile devices.</p>

<br>


<div align="center"">
<a href="https://flutter.dev/" target="_blank">
    <img src="https://img.shields.io/badge/Flutter-blue?style=for-the-badge&logo=flutter&logoColor=white" alt="Built with Flutter">
  </a>
  <a href="https://www.djangoproject.com/" target="_blank">
    <img src="https://img.shields.io/badge/Python%20Django-0C4B33?style=for-the-badge&logo=django&logoColor=white" alt="Powered by Django">
  </a>
  <a href="https://en.wikipedia.org/wiki/Convolutional_neural_network" target="_blank">
    <img src="https://img.shields.io/badge/Deep%20Learning-orange?style=for-the-badge&logo=cnn&logoColor=white" alt="Deep Learning">
  </a>
</div>


## Table of Contents

- [Motivation](#motivation)
- [Features](#features)
- [Design Overview](#design-overview)
- [Technologies Used](#technologies-used)
- [Demo](#demo)
- [Thesis](#thesis)

## Motivation

The Calorie Logging App was developed with a mission to empower users in taking charge of their nutrition and health. By leveraging advanced deep learning models for food item identification and image segmentation, the app provides a seamless and user-friendly experience for tracking calorie intake. Our motivation is to simplify the process of maintaining a healthy lifestyle, making it easier for users to make informed dietary choices and achieve their fitness goals. 

## Features

- **User Authentication**
  - Users can sign up and log in to their accounts to access personalized features.

- **Food Item Identification**
  - Users can capture an image of their food, and the app will automatically identify the food items using deep learning models.

- **Manual Food Search**
  - If the app couldn't identify a food item from the image, users have the option to search for the food manually.

- **Nutritional Information**
  - Users can view detailed nutritional information, including calories and macronutrients, for any food item in the app's database.

- **Food Logging**
  - Users can create, read, update, and delete food logs for any day, allowing them to track their calorie intake easily.

## Design Overview
Our solution consists mainly of 3 main components:

1. Classification Model that predicts that food item within a given image.
2. Segmentation Model that helps to determine the location of all the possible food items in the image. This step is crucial to be able to identify and categorize multiple food items in the input image.
3. A mobile app that allows users to capture an image of the food and be able to leverage the CNN models to track the calories in their food.

The following schematic shows the full process taken for identifying both the possible food categories in the image as well as their corresponding calories and macronutrients.

![Screenshot_28](https://github.com/AWahba1/Calorie-Logging-App/assets/87873253/3fad072a-d121-48d0-9dab-2602d7b3c60b)



## Technologies Used

The app is built using the following technologies:

- Flutter: A cross-platform UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- Django: A high-level Python web framework for rapid development and clean, pragmatic design.
- Convolutional Neural Networks: a class of deep learning that's commonly utilized for tasks such as image recognition and computer vision.


## Demo

To view the full demo, please click [here](https://drive.google.com/file/d/1LAABnp87Q12hHtuluHlF7ckRTzJmuC9I/view?usp=sharing).

## Thesis
To access the thesis document, please click [here](https://drive.google.com/file/d/17XcDl33Y10mDkyID60HMMTfI7UBYS25G/view?usp=sharing).
