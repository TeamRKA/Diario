# Team Project - *Diario*

**Diario** is an app that uses OCR to recognize dates and reminds the user using the inputted data.

Time spent: **X** hours spent in total

## Description
When you're a busy person, you tend to forget all of the dates and times that you see all around you. It's crucial to keep track of each of the events that you're associated with. That's what Diario is for.
Diario is an app that shows all of the events that you have currently saved and allows you to take pictures of fliers, posters, assignments, prescription bottles, etc. to save more events. It can also work with Facebook Events, so you can have all of your reminders in one place.
The challenge that we will face when developing this app is using OCR to successfully detect dates.

## User Stories

The following **required** functionality is completed:

- [ ] Application UI using AutoLayout
- [X] Implement OCR to recognize dates
- [X] Implement notifications

The following **optional** features are implemented:

- [ ] Support Facebook Events 
- [ ] Allow user to write notes
- [ ] Personal user accounts

<!--## Wireframe

![alt text]-->

## API
For this app, we will be using Google Cloud Vision's API (specifically its OCR endpoint) and FireBase for storing our own data.
For our FireBase API, we will need tables for users and events associated to the users (columns including date, time, title, note/description, and links).

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

![alt text](https://github.com/TeamRKA/Diario/blob/master/diarioDemo.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## License

    Copyright 2017 Team RKA

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
